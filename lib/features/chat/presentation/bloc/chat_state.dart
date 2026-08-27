import '../../domain/entities/chat_message.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState {
  final ChatStatus status;
  final String? conversationUuid;
  final String doctorUuid;
  final bool isAiBot;
  final bool needsAiConsent;
  final List<ChatMessage> messages;
  final bool isSending;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversationUuid,
    this.doctorUuid = '',
    this.isAiBot = false,
    this.needsAiConsent = false,
    this.messages = const [],
    this.isSending = false,
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    String? conversationUuid,
    String? doctorUuid,
    bool? isAiBot,
    bool? needsAiConsent,
    List<ChatMessage>? messages,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversationUuid: conversationUuid ?? this.conversationUuid,
      doctorUuid: doctorUuid ?? this.doctorUuid,
      isAiBot: isAiBot ?? this.isAiBot,
      needsAiConsent: needsAiConsent ?? this.needsAiConsent,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }
}
