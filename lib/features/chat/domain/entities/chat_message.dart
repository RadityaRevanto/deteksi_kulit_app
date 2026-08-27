class ChatMessage {
  final String uuid;
  final String senderUuid;
  final String senderName;
  final String senderRole; // 'user' or 'doctor'
  final String content;
  final String type; // 'text', 'image', 'video'
  final String? mediaUrl;
  final DateTime createdAt;
  final bool isUserSender;

  const ChatMessage({
    required this.uuid,
    required this.senderUuid,
    required this.senderName,
    required this.senderRole,
    required this.content,
    required this.type,
    this.mediaUrl,
    required this.createdAt,
    required this.isUserSender,
  });
}
