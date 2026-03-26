import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/core/models/clinic_models.dart';

class ClinicApiService {
  final StorageService _storageService = StorageService();

  // Get auth headers with token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ============================================
  // PUBLIC LIST-ALL ENDPOINTS
  // ============================================

  Future<List<ClinicDetails>> getAllClinics() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get all clinics: ${response.body}');
    }
  }

  Future<List<ClinicBranch>> getAllBranches() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/branches/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get all clinic branches: ${response.body}');
    }
  }

  Future<List<ClinicService>> getAllServices() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/services/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicService.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get all clinic services: ${response.body}');
    }
  }

  // ============================================
  // CLINIC DETAILS ENDPOINTS
  // ============================================

  Future<ClinicDetails> createClinicDetails(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/details'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return ClinicDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create clinic details: ${response.body}');
    }
  }

  Future<ClinicDetails> getMyClinicDetails() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/details'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return ClinicDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get clinic details: ${response.body}');
    }
  }

  Future<ClinicDetails> getClinicDetails(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/details/$userId'),
    );

    if (response.statusCode == 200) {
      return ClinicDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get clinic details: ${response.body}');
    }
  }

  Future<ClinicDetails> updateClinicDetails(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/details'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return ClinicDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update clinic details: ${response.body}');
    }
  }

  // ============================================
  // CLINIC BRANCH ENDPOINTS
  // ============================================

  Future<ClinicBranch> createBranch(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/branches'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return ClinicBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create branch: ${response.body}');
    }
  }

  Future<List<ClinicBranch>> getMyBranches() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/branches'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get branches: ${response.body}');
    }
  }

  Future<List<ClinicBranch>> getClinicBranches(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/branches/clinic/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get clinic branches: ${response.body}');
    }
  }

  Future<ClinicBranch> getBranch(String branchId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/branches/$branchId'),
    );

    if (response.statusCode == 200) {
      return ClinicBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get branch: ${response.body}');
    }
  }

  Future<ClinicBranch> updateBranch(String branchId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/branches/$branchId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return ClinicBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update branch: ${response.body}');
    }
  }

  Future<void> deleteBranch(String branchId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/branches/$branchId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete branch: ${response.body}');
    }
  }

  // ============================================
  // CLINIC SERVICE ENDPOINTS
  // ============================================

  Future<ClinicService> createService(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/services'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return ClinicService.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create service: ${response.body}');
    }
  }

  Future<List<ClinicService>> getMyServices() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/services'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicService.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get services: ${response.body}');
    }
  }

  Future<List<ClinicService>> getClinicServices(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/services/clinic/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicService.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get clinic services: ${response.body}');
    }
  }

  Future<ClinicService> getService(String serviceId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/services/$serviceId'),
    );

    if (response.statusCode == 200) {
      return ClinicService.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get service: ${response.body}');
    }
  }

  Future<ClinicService> updateService(String serviceId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/services/$serviceId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return ClinicService.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update service: ${response.body}');
    }
  }

  Future<void> deleteService(String serviceId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/services/$serviceId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete service: ${response.body}');
    }
  }

  // ============================================
  // CLINIC BOOKING ENDPOINTS
  // ============================================

  Future<ClinicBooking> createBooking(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/bookings'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return ClinicBooking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  Future<List<ClinicBooking>> getMyBookings() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/bookings'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicBooking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get bookings: ${response.body}');
    }
  }

  Future<List<ClinicBooking>> getBranchBookings(String branchId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/bookings/branch/$branchId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClinicBooking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get branch bookings: ${response.body}');
    }
  }

  Future<ClinicBooking> getBooking(String bookingId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/bookings/$bookingId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return ClinicBooking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get booking: ${response.body}');
    }
  }

  Future<ClinicBooking> updateBooking(String bookingId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/bookings/$bookingId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return ClinicBooking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update booking: ${response.body}');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/clinics/bookings/$bookingId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete booking: ${response.body}');
    }
  }
}
