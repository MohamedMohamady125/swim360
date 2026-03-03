/// API Configuration for Swim360 Backend
class ApiConfig {
  // Base URL - Change this based on your environment
  static const String baseUrl = 'http://localhost:8000';

  // For Android Emulator, use: 'http://10.0.2.2:8000'
  // For iOS Simulator, use: 'http://localhost:8000'
  // For physical device on same network, use: 'http://YOUR_COMPUTER_IP:8000'

  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // Auth endpoints
  static const String loginEndpoint = '$apiPrefix/auth/login';
  static const String signupEndpoint = '$apiPrefix/auth/signup';
  static const String refreshTokenEndpoint = '$apiPrefix/auth/refresh';
  static const String logoutEndpoint = '$apiPrefix/auth/logout';

  // User endpoints
  static const String profileEndpoint = '$apiPrefix/users/profile';

  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
