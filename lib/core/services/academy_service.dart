import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/core/models/academy_models.dart';

class AcademyService {
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

  Future<List<AcademyDetails>> getAllAcademies() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get all academies: ${response.body}');
    }
  }

  Future<List<AcademyBranch>> getAllBranches() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/branches/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get all branches: ${response.body}');
    }
  }

  Future<List<AcademyProgram>> getAllPrograms() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/programs/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyProgram.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get all programs: ${response.body}');
    }
  }

  // ============================================
  // ACADEMY DETAILS ENDPOINTS
  // ============================================

  Future<AcademyDetails> createAcademyDetails(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/details'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return AcademyDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create academy details: ${response.body}');
    }
  }

  Future<AcademyDetails> getMyAcademyDetails() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/details'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return AcademyDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get academy details: ${response.body}');
    }
  }

  Future<AcademyDetails> getAcademyDetails(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/details/$userId'),
    );

    if (response.statusCode == 200) {
      return AcademyDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get academy details: ${response.body}');
    }
  }

  Future<AcademyDetails> updateAcademyDetails(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/details'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return AcademyDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update academy details: ${response.body}');
    }
  }

  // ============================================
  // ACADEMY BRANCH ENDPOINTS
  // ============================================

  Future<AcademyBranch> createBranch(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/branches'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return AcademyBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create branch: ${response.body}');
    }
  }

  Future<List<AcademyBranch>> getMyBranches() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/branches'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get branches: ${response.body}');
    }
  }

  Future<List<AcademyBranch>> getAcademyBranches(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/branches/academy/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get academy branches: ${response.body}');
    }
  }

  Future<AcademyBranch> getBranch(String branchId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/branches/$branchId'),
    );

    if (response.statusCode == 200) {
      return AcademyBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get branch: ${response.body}');
    }
  }

  Future<AcademyBranch> updateBranch(String branchId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/branches/$branchId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return AcademyBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update branch: ${response.body}');
    }
  }

  Future<void> deleteBranch(String branchId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/branches/$branchId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete branch: ${response.body}');
    }
  }

  // ============================================
  // ACADEMY POOL ENDPOINTS
  // ============================================

  Future<AcademyPool> createPool(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/pools'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return AcademyPool.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create pool: ${response.body}');
    }
  }

  Future<List<AcademyPool>> getBranchPools(String branchId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/pools/branch/$branchId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyPool.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get pools: ${response.body}');
    }
  }

  Future<AcademyPool> updatePool(String poolId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/pools/$poolId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return AcademyPool.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update pool: ${response.body}');
    }
  }

  Future<void> deletePool(String poolId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/pools/$poolId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete pool: ${response.body}');
    }
  }

  // ============================================
  // ACADEMY PROGRAM ENDPOINTS
  // ============================================

  Future<AcademyProgram> createProgram(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/programs'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return AcademyProgram.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create program: ${response.body}');
    }
  }

  Future<List<AcademyProgram>> getMyPrograms() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/programs'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyProgram.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get programs: ${response.body}');
    }
  }

  Future<List<AcademyProgram>> getAcademyPrograms(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/programs/academy/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyProgram.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get academy programs: ${response.body}');
    }
  }

  Future<AcademyProgram> getProgram(String programId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/programs/$programId'),
    );

    if (response.statusCode == 200) {
      return AcademyProgram.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get program: ${response.body}');
    }
  }

  Future<AcademyProgram> updateProgram(String programId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/programs/$programId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return AcademyProgram.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update program: ${response.body}');
    }
  }

  Future<void> deleteProgram(String programId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/programs/$programId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete program: ${response.body}');
    }
  }

  // ============================================
  // ACADEMY SWIMMER ENDPOINTS
  // ============================================

  Future<AcademySwimmer> createSwimmer(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/swimmers'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return AcademySwimmer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create swimmer: ${response.body}');
    }
  }

  Future<List<AcademySwimmer>> getMySwimmers() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/swimmers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademySwimmer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get swimmers: ${response.body}');
    }
  }

  Future<AcademySwimmer> getSwimmer(String swimmerId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/swimmers/$swimmerId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return AcademySwimmer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get swimmer: ${response.body}');
    }
  }

  Future<AcademySwimmer> updateSwimmer(String swimmerId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/swimmers/$swimmerId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return AcademySwimmer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update swimmer: ${response.body}');
    }
  }

  Future<void> deleteSwimmer(String swimmerId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/swimmers/$swimmerId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete swimmer: ${response.body}');
    }
  }

  // ============================================
  // ACADEMY COACH ENDPOINTS
  // ============================================

  Future<AcademyCoach> createCoach(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/coaches'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return AcademyCoach.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create coach: ${response.body}');
    }
  }

  Future<List<AcademyCoach>> getMyCoaches() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/coaches'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyCoach.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get coaches: ${response.body}');
    }
  }

  Future<List<AcademyCoach>> getAcademyCoaches(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/coaches/academy/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AcademyCoach.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get academy coaches: ${response.body}');
    }
  }

  Future<AcademyCoach> getCoach(String coachId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/coaches/$coachId'),
    );

    if (response.statusCode == 200) {
      return AcademyCoach.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get coach: ${response.body}');
    }
  }

  Future<AcademyCoach> updateCoach(String coachId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/coaches/$coachId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return AcademyCoach.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update coach: ${response.body}');
    }
  }

  Future<void> deleteCoach(String coachId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/academies/coaches/$coachId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete coach: ${response.body}');
    }
  }
}
