import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// Model classes for API responses
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final UserData? user;

  LoginResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;

  UserData({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
    };
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  // Base URL - Update this with your actual backend URL
  static const String _baseUrl = kDebugMode 
      ? 'http://localhost:8000/api'  // Development URL
      : 'https://your-production-api.com/api';  // Production URL

  static const Duration _timeout = Duration(seconds: 30);
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Store access token for authenticated requests
  String? _accessToken;
  
  // Getters and setters for token management
  String? get accessToken => _accessToken;
  
  void setAccessToken(String? token) {
    _accessToken = token;
  }

  void clearToken() {
    _accessToken = null;
  }

  // Helper method to get headers
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    
    return headers;
  }

  // Helper method to handle HTTP responses
  dynamic _handleResponse(http.Response response) {
    if (kDebugMode) {
      print('API Response: ${response.statusCode} - ${response.body}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      String errorMessage = 'Request failed';
      
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['detail'] ?? errorData['message'] ?? errorMessage;
      } catch (e) {
        errorMessage = 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
      }
      
      throw ApiException(errorMessage, statusCode: response.statusCode);
    }
  }

  // Login method
  Future<LoginResponse> login(String email, String password) async {
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      
      if (kDebugMode) {
        print('Attempting login for: $email');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: _getHeaders(includeAuth: false),
        body: json.encode(loginRequest.toJson()),
      ).timeout(_timeout);

      final responseData = _handleResponse(response);
      final loginResponse = LoginResponse.fromJson(responseData);

      // Store access token if login successful
      if (loginResponse.success && loginResponse.accessToken != null) {
        setAccessToken(loginResponse.accessToken);
      }

      return loginResponse;
      
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on HttpException {
      throw ApiException('Network error occurred. Please try again.');
    } on FormatException {
      throw ApiException('Invalid response format from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // If you have a logout endpoint on your backend, call it here
      if (_accessToken != null) {
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: _getHeaders(),
        ).timeout(_timeout);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Logout request failed: $e');
      }
      // Continue with local logout even if server request fails
    } finally {
      clearToken();
    }
  }

  // Refresh token method (if you implement refresh tokens)
  Future<bool> refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: _getHeaders(includeAuth: false),
      ).timeout(_timeout);

      final responseData = _handleResponse(response);
      
      if (responseData['access_token'] != null) {
        setAccessToken(responseData['access_token']);
        return true;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh failed: $e');
      }
      return false;
    }
  }

  // Generic GET request method
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(),
      ).timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('GET request failed: ${e.toString()}');
    }
  }

  // Generic POST request method
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(),
        body: json.encode(data),
      ).timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('POST request failed: ${e.toString()}');
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _accessToken != null;

  // Method to validate current session
  Future<bool> validateSession() async {
    if (!isAuthenticated) return false;
    
    try {
      // Try to make an authenticated request to validate token
      await get('/auth/me'); // Adjust endpoint as needed
      return true;
    } catch (e) {
      // Token might be expired, try to refresh
      if (await refreshToken()) {
        return true;
      }
      clearToken();
      return false;
    }
  }
}