import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/auth/auth_response.dart';

/// Service for secure storage of tokens and user data
/// Uses flutter_secure_storage for mobile and shared_preferences for web
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  /// Write value to storage (handles both web and mobile)
  Future<void> _write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await _secureStorage.write(key: key, value: value);
    }
  }

  /// Read value from storage (handles both web and mobile)
  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await _secureStorage.read(key: key);
    }
  }

  /// Delete value from storage (handles both web and mobile)
  Future<void> _delete(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } else {
      await _secureStorage.delete(key: key);
    }
  }

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _write(_accessTokenKey, token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _read(_accessTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _write(_refreshTokenKey, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _read(_refreshTokenKey);
  }

  /// Save user data
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _write(_userKey, userJson);
  }

  /// Get user data
  Future<User?> getUser() async {
    final userJson = await _read(_userKey);
    if (userJson != null) {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      return User.fromJson(userData);
    }
    return null;
  }

  /// Save authentication data (tokens + user)
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveUser(user),
    ]);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all authentication data (logout)
  Future<void> clearAuthData() async {
    await Future.wait([
      _delete(_accessTokenKey),
      _delete(_refreshTokenKey),
      _delete(_userKey),
    ]);
  }

  /// Clear all storage
  Future<void> clearAll() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } else {
      await _secureStorage.deleteAll();
    }
  }
}
