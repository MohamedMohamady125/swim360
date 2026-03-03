import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';
import '../models/auth/login_request.dart';
import '../models/auth/signup_request.dart';
import '../models/auth/auth_response.dart';
import 'storage_service.dart';

/// Authentication service for API calls
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final StorageService _storageService = StorageService();

  /// Login user
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}');

      final response = await http
          .post(
            url,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.connectTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(data);

        // Save tokens and user data
        if (authResponse.success &&
            authResponse.accessToken != null &&
            authResponse.refreshToken != null &&
            authResponse.user != null) {
          await _storageService.saveAuthData(
            accessToken: authResponse.accessToken!,
            refreshToken: authResponse.refreshToken!,
            user: authResponse.user!,
          );
        }

        return authResponse;
      } else {
        return AuthResponse(
          success: false,
          error: data['error'] ?? data['detail'] ?? 'Login failed',
        );
      }
    } on SocketException {
      return AuthResponse(
        success: false,
        error: 'No internet connection. Please check your network.',
      );
    } on http.ClientException {
      return AuthResponse(
        success: false,
        error: 'Failed to connect to server. Make sure the backend is running.',
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        error: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Signup user
  Future<AuthResponse> signup(SignupRequest request) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signupEndpoint}');

      final response = await http
          .post(
            url,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.connectTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(data);

        // Save tokens and user data
        if (authResponse.success &&
            authResponse.accessToken != null &&
            authResponse.refreshToken != null &&
            authResponse.user != null) {
          await _storageService.saveAuthData(
            accessToken: authResponse.accessToken!,
            refreshToken: authResponse.refreshToken!,
            user: authResponse.user!,
          );
        }

        return authResponse;
      } else {
        return AuthResponse(
          success: false,
          error: data['error'] ?? data['detail'] ?? 'Signup failed',
        );
      }
    } on SocketException {
      return AuthResponse(
        success: false,
        error: 'No internet connection. Please check your network.',
      );
    } on http.ClientException {
      return AuthResponse(
        success: false,
        error: 'Failed to connect to server. Make sure the backend is running.',
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        error: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final token = await _storageService.getAccessToken();

      if (token != null) {
        final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logoutEndpoint}');

        await http
            .post(
              url,
              headers: ApiConfig.authHeaders(token),
            )
            .timeout(ApiConfig.connectTimeout);
      }
    } catch (e) {
      // Continue with logout even if API call fails
      print('Logout API error: $e');
    } finally {
      // Always clear local data
      await _storageService.clearAuthData();
    }
  }

  /// Get current user from storage
  Future<User?> getCurrentUser() async {
    return await _storageService.getUser();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  /// Refresh access token
  Future<AuthResponse> refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();

      if (refreshToken == null) {
        return AuthResponse(
          success: false,
          error: 'No refresh token found',
        );
      }

      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshTokenEndpoint}');

      final response = await http
          .post(
            url,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(ApiConfig.connectTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(data);

        // Update tokens
        if (authResponse.success && authResponse.accessToken != null) {
          await _storageService.saveAccessToken(authResponse.accessToken!);

          if (authResponse.refreshToken != null) {
            await _storageService.saveRefreshToken(authResponse.refreshToken!);
          }
        }

        return authResponse;
      } else {
        return AuthResponse(
          success: false,
          error: data['error'] ?? 'Token refresh failed',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        error: 'Token refresh failed: ${e.toString()}',
      );
    }
  }
}
