import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<String> getOrCreateConversation(String doctorUuid);
  Future<List<ChatMessageModel>> getMessages(String conversationUuid);
  Future<ChatMessageModel> sendMessage(
    String conversationUuid, {
    String? content,
    File? media,
  });
  Future<bool> getAiConsent();
  Future<void> setAiConsent(bool accepted);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClientImpl();

  @override
  Future<String> getOrCreateConversation(String doctorUuid) async {
    try {
      if (doctorUuid.isEmpty) {
        final aiResponse = await apiClient.post('/ai-chat/conversations');
        if (aiResponse.containsKey('data') && aiResponse['data'] is Map<String, dynamic>) {
          final data = aiResponse['data'] as Map<String, dynamic>;
          final uuid = data['uuid']?.toString();
          if (uuid != null && uuid.isNotEmpty) return uuid;
        }
      }
    } catch (_) {}

    final response = await apiClient.post(
      '/conversations',
      body: doctorUuid.isNotEmpty ? {'doctor_id': doctorUuid} : {},
    );

    if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      final data = response['data'] as Map<String, dynamic>;
      final uuid = data['uuid']?.toString();
      if (uuid != null && uuid.isNotEmpty) {
        return uuid;
      }
    }
    throw Exception('Gagal membuat ruang percakapan.');
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationUuid) async {
    final response = await apiClient.get('/conversations/$conversationUuid/messages?per_page=50');
    final list = <ChatMessageModel>[];

    if (response.containsKey('data') && response['data'] is List) {
      for (final item in response['data'] as List) {
        if (item is Map<String, dynamic>) {
          list.add(ChatMessageModel.fromJson(item));
        }
      }
    }
    return list;
  }

  @override
  Future<ChatMessageModel> sendMessage(
    String conversationUuid, {
    String? content,
    File? media,
  }) async {
    final fields = <String, String>{};
    if (content != null && content.trim().isNotEmpty) {
      fields['content'] = content.trim();
    }

    final files = <String, File>{};
    if (media != null) {
      files['media'] = media;
    }

    final response = await apiClient.postMultipart(
      '/conversations/$conversationUuid/messages',
      fields: fields,
      files: files,
    );

    if (response.containsKey('data')) {
      final rawData = response['data'];
      Map<String, dynamic> msgMap = {};
      if (rawData is Map<String, dynamic>) {
        if (rawData.containsKey('message') && rawData['message'] is Map<String, dynamic>) {
          msgMap = rawData['message'] as Map<String, dynamic>;
        } else {
          msgMap = rawData;
        }
      }
      if (msgMap.isNotEmpty) {
        return ChatMessageModel.fromJson(msgMap);
      }
    }

    return ChatMessageModel(
      uuid: DateTime.now().millisecondsSinceEpoch.toString(),
      senderUuid: '',
      senderName: 'Saya',
      senderRole: 'user',
      content: content ?? '',
      type: media != null ? 'image' : 'text',
      mediaUrl: media?.path,
      createdAt: DateTime.now(),
      isUserSender: true,
    );
  }

  @override
  Future<bool> getAiConsent() async {
    try {
      final response = await apiClient.get('/ai-chat/consent');
      if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
        final data = response['data'] as Map<String, dynamic>;
        return data['accepted'] == true;
      }
    } catch (_) {}
    return false;
  }

  @override
  Future<void> setAiConsent(bool accepted) async {
    await apiClient.post(
      '/ai-chat/consent',
      body: {'accepted': accepted},
    );
  }
}
