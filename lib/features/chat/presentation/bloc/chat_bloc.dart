import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/chat_remote_data_source.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRemoteDataSource remoteDataSource;
  Timer? _pollingTimer;

  ChatBloc({ChatRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? ChatRemoteDataSourceImpl(),
        super(const ChatState()) {
    on<InitChatEvent>(_onInitChat);
    on<FetchMessagesEvent>(_onFetchMessages);
    on<SendTextMessageEvent>(_onSendTextMessage);
    on<SendImageMessageEvent>(_onSendImageMessage);
    on<AcceptAiConsentEvent>(_onAcceptAiConsent);
  }

  Future<void> _onInitChat(
    InitChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      status: ChatStatus.loading,
      doctorUuid: event.doctorUuid,
      isAiBot: event.isAiBot,
    ));

    try {
      if (event.isAiBot) {
        final accepted = await remoteDataSource.getAiConsent();
        if (!accepted) {
          emit(state.copyWith(
            status: ChatStatus.success,
            needsAiConsent: true,
          ));
          return;
        }
      }

      String convUuid = event.conversationUuid ?? '';
      if (convUuid.isEmpty) {
        convUuid = await remoteDataSource.getOrCreateConversation(event.doctorUuid);
      }

      emit(state.copyWith(
        conversationUuid: convUuid,
        needsAiConsent: false,
      ));

      add(const FetchMessagesEvent());

      if (event.initialMessage != null && event.initialMessage!.trim().isNotEmpty) {
        add(SendTextMessageEvent(event.initialMessage!));
      }

      // Start 3s polling timer for new messages
      _startPolling();
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onAcceptAiConsent(
    AcceptAiConsentEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await remoteDataSource.setAiConsent(true);
      emit(state.copyWith(needsAiConsent: false));
      add(InitChatEvent(
        doctorUuid: state.doctorUuid,
        isAiBot: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal menyetujui persetujuan AI',
      ));
    }
  }

  Future<void> _onFetchMessages(
    FetchMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationUuid == null || state.conversationUuid!.isEmpty) return;

    if (!event.isSilent) {
      emit(state.copyWith(status: ChatStatus.loading));
    }

    try {
      final messages = await remoteDataSource.getMessages(state.conversationUuid!);
      emit(state.copyWith(
        status: ChatStatus.success,
        messages: messages,
      ));
    } catch (e) {
      if (!event.isSilent) {
        emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> _onSendTextMessage(
    SendTextMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationUuid == null || event.message.trim().isEmpty) return;

    emit(state.copyWith(isSending: true));

    // Optimistic local add
    final localMsg = ChatMessage(
      uuid: DateTime.now().millisecondsSinceEpoch.toString(),
      senderUuid: '',
      senderName: 'Saya',
      senderRole: 'user',
      content: event.message.trim(),
      type: 'text',
      createdAt: DateTime.now(),
      isUserSender: true,
    );

    final updated = List<ChatMessage>.from(state.messages)..add(localMsg);
    emit(state.copyWith(messages: updated));

    try {
      await remoteDataSource.sendMessage(
        state.conversationUuid!,
        content: event.message,
      );
      emit(state.copyWith(isSending: false));
      add(const FetchMessagesEvent(isSilent: true));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onSendImageMessage(
    SendImageMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.conversationUuid == null) return;

    emit(state.copyWith(isSending: true));

    try {
      await remoteDataSource.sendMessage(
        state.conversationUuid!,
        media: event.imageFile,
      );
      emit(state.copyWith(isSending: false));
      add(const FetchMessagesEvent(isSilent: true));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!isClosed && state.conversationUuid != null && state.conversationUuid!.isNotEmpty) {
        add(const FetchMessagesEvent(isSilent: true));
      }
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
