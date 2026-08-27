import 'dart:io';

abstract class ChatEvent {
  const ChatEvent();
}

class InitChatEvent extends ChatEvent {
  final String doctorUuid;
  final String? conversationUuid;
  final bool isAiBot;
  final String? initialMessage;

  const InitChatEvent({
    required this.doctorUuid,
    this.conversationUuid,
    this.isAiBot = false,
    this.initialMessage,
  });
}

class FetchMessagesEvent extends ChatEvent {
  final bool isSilent;

  const FetchMessagesEvent({this.isSilent = false});
}

class SendTextMessageEvent extends ChatEvent {
  final String message;

  const SendTextMessageEvent(this.message);
}

class SendImageMessageEvent extends ChatEvent {
  final File imageFile;

  const SendImageMessageEvent(this.imageFile);
}

class AcceptAiConsentEvent extends ChatEvent {}
