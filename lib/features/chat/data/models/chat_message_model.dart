import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.uuid,
    required super.senderUuid,
    required super.senderName,
    required super.senderRole,
    required super.content,
    required super.type,
    super.mediaUrl,
    required super.createdAt,
    required super.isUserSender,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, {String? currentUserUuid}) {
    final senderMap = json['sender'] as Map<String, dynamic>? ?? {};
    final senderUuid = senderMap['uuid']?.toString() ?? '';
    final senderRole = senderMap['role']?.toString() ?? 'doctor';
    final senderName = senderMap['full_name']?.toString() ?? 'Dokter';

    DateTime parsedDate = DateTime.now();
    try {
      if (json['created_at'] != null) {
        parsedDate = DateTime.parse(json['created_at'].toString()).toLocal();
      }
    } catch (_) {}

    final isUser = (senderRole == 'user') || (currentUserUuid != null && senderUuid == currentUserUuid);

    return ChatMessageModel(
      uuid: json['uuid']?.toString() ?? '',
      senderUuid: senderUuid,
      senderName: senderName,
      senderRole: senderRole,
      content: json['content']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      mediaUrl: json['media_url']?.toString(),
      createdAt: parsedDate,
      isUserSender: isUser,
    );
  }
}
