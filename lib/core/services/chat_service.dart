import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/core/models/chat_models.dart';

class ChatService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Conversation>> getConversations({int skip = 0, int limit = 20}) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/chat/conversations')
        .replace(queryParameters: {'skip': skip.toString(), 'limit': limit.toString()});

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> conversations = body['conversations'];
      return conversations.map((json) => Conversation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get conversations: ${response.body}');
    }
  }

  Future<Conversation> createConversation(String otherUserId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/chat/conversations'),
      headers: headers,
      body: jsonEncode({'participant_2_id': otherUserId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Conversation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create conversation: ${response.body}');
    }
  }

  Future<List<Message>> getMessages(String conversationId, {int skip = 0, int limit = 50}) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/chat/conversations/$conversationId/messages')
        .replace(queryParameters: {'skip': skip.toString(), 'limit': limit.toString()});

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> messages = body['messages'];
      return messages.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get messages: ${response.body}');
    }
  }

  Future<Message> sendMessage(String conversationId, String text, {String? attachmentUrl, String? attachmentType}) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/chat/messages'),
      headers: headers,
      body: jsonEncode({
        'conversation_id': conversationId,
        'message_text': text,
        if (attachmentUrl != null) 'attachment_url': attachmentUrl,
        if (attachmentType != null) 'attachment_type': attachmentType,
      }),
    );

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  Future<void> markMessageRead(String messageId) async {
    final headers = await _getHeaders();
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/chat/messages/$messageId/read'),
      headers: headers,
    );
  }
}
