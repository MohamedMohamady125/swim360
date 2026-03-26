import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/core/models/notification_models.dart';

class NotificationService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<({List<NotificationModel> notifications, int total, int unreadCount})> getNotifications({
    bool unreadOnly = false,
    int skip = 0,
    int limit = 20,
  }) async {
    final headers = await _getHeaders();
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    if (unreadOnly) queryParams['unread_only'] = 'true';

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/reviews/notifications')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> items = body['notifications'];
      return (
        notifications: items.map((json) => NotificationModel.fromJson(json)).toList(),
        total: body['total'] as int,
        unreadCount: body['unread_count'] as int,
      );
    } else {
      throw Exception('Failed to get notifications: ${response.body}');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final headers = await _getHeaders();
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/reviews/notifications/$notificationId/read'),
      headers: headers,
    );
  }

  Future<void> markAllRead() async {
    final headers = await _getHeaders();
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/reviews/notifications/read-all'),
      headers: headers,
    );
  }
}
