import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/core/models/store_models.dart';

class StoreApiService {
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
  // STORE DETAILS ENDPOINTS
  // ============================================

  Future<StoreDetails> createStoreDetails(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/details'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return StoreDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create store details: ${response.body}');
    }
  }

  Future<StoreDetails> getMyStoreDetails() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/details'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return StoreDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get store details: ${response.body}');
    }
  }

  Future<StoreDetails> getStoreDetails(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/details/$userId'),
    );

    if (response.statusCode == 200) {
      return StoreDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get store details: ${response.body}');
    }
  }

  Future<StoreDetails> updateStoreDetails(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/details'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return StoreDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update store details: ${response.body}');
    }
  }

  // ============================================
  // STORE BRANCH ENDPOINTS
  // ============================================

  Future<StoreBranch> createBranch(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/branches'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return StoreBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create branch: ${response.body}');
    }
  }

  Future<List<StoreBranch>> getMyBranches() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/branches'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StoreBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get branches: ${response.body}');
    }
  }

  Future<List<StoreBranch>> getStoreBranches(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/branches/store/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StoreBranch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get store branches: ${response.body}');
    }
  }

  Future<StoreBranch> updateBranch(String branchId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/branches/$branchId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return StoreBranch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update branch: ${response.body}');
    }
  }

  Future<void> deleteBranch(String branchId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/branches/$branchId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete branch: ${response.body}');
    }
  }

  // ============================================
  // STORE PRODUCT ENDPOINTS
  // ============================================

  Future<StoreProduct> createProduct(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/products'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return StoreProduct.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<List<StoreProduct>> getMyProducts() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/products'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StoreProduct.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get products: ${response.body}');
    }
  }

  Future<List<StoreProduct>> getStoreProducts(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/products/store/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StoreProduct.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get store products: ${response.body}');
    }
  }

  Future<StoreProduct> getProduct(String productId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/products/$productId'),
    );

    if (response.statusCode == 200) {
      return StoreProduct.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get product: ${response.body}');
    }
  }

  Future<StoreProduct> updateProduct(String productId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/products/$productId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return StoreProduct.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/products/$productId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.body}');
    }
  }

  // ============================================
  // STORE ORDER ENDPOINTS
  // ============================================

  Future<StoreOrder> createOrder(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/orders'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return StoreOrder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<List<StoreOrder>> getMyOrders() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/orders'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StoreOrder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get orders: ${response.body}');
    }
  }

  Future<StoreOrder> getOrder(int orderId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/orders/$orderId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return StoreOrder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get order: ${response.body}');
    }
  }

  Future<StoreOrder> updateOrder(int orderId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/orders/$orderId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return StoreOrder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update order: ${response.body}');
    }
  }

  Future<StoreOrder> updateOrderStatus(int orderId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/stores/orders/$orderId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return StoreOrder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update order status: ${response.body}');
    }
  }

  // ============================================
  // MARKETPLACE (USED ITEMS) ENDPOINTS
  // ============================================

  Future<UsedItem> createUsedItem(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/marketplace/items'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return UsedItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create used item: ${response.body}');
    }
  }

  Future<List<UsedItem>> getMarketplaceItems({
    String? category,
    String? condition,
    double? minPrice,
    double? maxPrice,
    String? search,
    String? city,
    String? governorate,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (condition != null) queryParams['condition'] = condition;
    if (minPrice != null) queryParams['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
    if (search != null) queryParams['search'] = search;
    if (city != null) queryParams['city'] = city;
    if (governorate != null) queryParams['governorate'] = governorate;

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/marketplace/items')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UsedItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get marketplace items: ${response.body}');
    }
  }

  Future<List<UsedItem>> getMyUsedItems() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/marketplace/items/my'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UsedItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get my used items: ${response.body}');
    }
  }

  Future<UsedItem> getUsedItem(String itemId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/marketplace/items/$itemId'),
    );

    if (response.statusCode == 200) {
      return UsedItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get used item: ${response.body}');
    }
  }

  Future<UsedItem> updateUsedItem(String itemId, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/marketplace/items/$itemId'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return UsedItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update used item: ${response.body}');
    }
  }

  Future<void> deleteUsedItem(String itemId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/marketplace/items/$itemId'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete used item: ${response.body}');
    }
  }
}
