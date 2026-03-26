import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/core/models/event_models.dart';

class EventService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<EventModel>> getEvents({
    String? eventType,
    String? city,
    String? governorate,
    bool? isOnline,
    bool? isFeatured,
    int skip = 0,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    if (eventType != null) queryParams['event_type'] = eventType;
    if (city != null) queryParams['city'] = city;
    if (governorate != null) queryParams['governorate'] = governorate;
    if (isOnline != null) queryParams['is_online'] = isOnline.toString();
    if (isFeatured != null) queryParams['is_featured'] = isFeatured.toString();

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> events = body['events'];
      return events.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get events: ${response.body}');
    }
  }

  Future<EventModel> getEvent(String eventId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events/$eventId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return EventModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get event: ${response.body}');
    }
  }

  Future<List<EventModel>> getMyEvents({int skip = 0, int limit = 100}) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events/my')
        .replace(queryParameters: {'skip': skip.toString(), 'limit': limit.toString()});

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> events = body['events'];
      return events.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get my events: ${response.body}');
    }
  }

  Future<EventModel> createEvent(Map<String, dynamic> eventData) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events'),
      headers: headers,
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 201) {
      return EventModel.fromJson(jsonDecode(response.body));
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Failed to create event');
    }
  }

  Future<EventModel> updateEvent(String eventId, Map<String, dynamic> updates) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events/$eventId'),
      headers: headers,
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return EventModel.fromJson(jsonDecode(response.body));
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Failed to update event');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events/$eventId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Failed to delete event');
    }
  }

  Future<List<Map<String, dynamic>>> getEventRegistrations(String eventId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events/$eventId/registrations'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get registrations: ${response.body}');
    }
  }

  Future<void> registerForEvent(String eventId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/events/$eventId/register'),
      headers: headers,
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Failed to register for event');
    }
  }
}
