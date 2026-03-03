import 'package:flutter/material.dart';
import 'package:swim360/core/services/store_service.dart';
import 'package:swim360/core/models/store_models.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final StoreApiService _storeService = StoreApiService();

  String _view = 'list'; // 'list' or 'edit'
  String? _activeModal; // 'stock', 'discount', 'promo', 'global-promo'
  StoreProduct? _editingProduct;
  StoreProduct? _selectedProduct;

  List<StoreProduct> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _categories = ["Cap", "Goggles", "Suit", "Kickboard", "Paddles", "Fins", "Snorkels", "Other"];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final products = await _storeService.getMyProducts();

      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load products: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: const Color(0xFF1F2937)));
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading && _products.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading products...'),
            ],
          ),
        ),
      );
    }

    // Show error state
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
                const SizedBox(height: 16),
                Text(_errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: _view == 'list' ? _buildInventoryList() : _buildEditForm(),
          ),
          if (_activeModal != null) _buildModal(),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    final Map<String, List<StoreProduct>> grouped = {};
    for (var product in _products) {
      grouped.putIfAbsent(product.category ?? 'Other', () => []).add(product);
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Inventory', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
        const SizedBox(height: 4),
        const Text('Manage your products and promotions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
        const SizedBox(height: 32),

        // Global Promo Banner
        InkWell(
          onTap: () => setState(() => _activeModal = 'global-promo'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF97316),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFFF97316).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text('GLOBAL STORE PROMO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                  ],
                ),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Categorized Products
        ...grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(entry.key.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                ],
              ),
              const SizedBox(height: 16),
              ...entry.value.map((product) {
                final isFullyOOS = false; // Simplified for now
                final isPartialOOS = false; // Simplified for now

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: (product.photoUrl != null && product.photoUrl!.isNotEmpty)
                            ? Image.network(product.photoUrl!, width: 96, height: 96, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(width: 96, height: 96, color: const Color(0xFFF3F4F6), child: const Icon(Icons.image_not_supported, color: Color(0xFF9CA3AF))))
                            : Container(width: 96, height: 96, color: const Color(0xFFF3F4F6), child: const Icon(Icons.image, color: Color(0xFF9CA3AF))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                                  if (isFullyOOS) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(4)), child: const Text('OOS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))))
                                  else if (isPartialOOS) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)), child: const Text('Partial', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFF59E0B))))
                                  else Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)), child: const Text('Live', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF10B981)))),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (product.brand != null && product.brand!.isNotEmpty) Text(product.brand!.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                              if (product.brand != null && product.brand!.isNotEmpty) const SizedBox(height: 8),
                              Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => setState(() {
                                    _editingProduct = product as StoreProduct;
                                    _view = 'edit';
                                  }),
                                  child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.edit, color: Color(0xFF2563EB), size: 16)),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () => setState(() {
                                    _selectedProduct = product as StoreProduct;
                                    _activeModal = 'stock';
                                  }),
                                  child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 16)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => setState(() {
                                    _selectedProduct = product as StoreProduct;
                                    _activeModal = 'discount';
                                  }),
                                  child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_offer, color: Color(0xFF10B981), size: 16)),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () => setState(() {
                                    _selectedProduct = product as StoreProduct;
                                    _activeModal = 'promo';
                                  }),
                                  child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.confirmation_number, color: Color(0xFFF59E0B), size: 16)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _view = 'list'),
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.arrow_back, size: 24)),
                  ),
                  const SizedBox(width: 16),
                  const Text('Edit Product', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
              InkWell(
                onTap: () async {
                  if (_editingProduct == null) return;

                  try {
                    setState(() => _isLoading = true);

                    final data = _editingProduct!.toJson();
                    await _storeService.updateProduct(_editingProduct!.id, data);
                    await _loadProducts();

                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _view = 'list';
                      });
                      _showNotification('Product information saved!');
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() => _isLoading = false);
                      _showNotification('Failed to save product: $e');
                    }
                  }
                },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]), child: Text(_isLoading ? 'SAVING...' : 'SAVE', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0))),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.layers, color: Color(0xFF2563EB), size: 16), SizedBox(width: 8), Text('INFORMATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0))]),
                    const SizedBox(height: 16),
                    const Text('Title', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: _editingProduct?.name),
                      decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF9FAFB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16)),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModal() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _activeModal = null),
        child: Container(
          color: const Color(0xFF0F172A).withOpacity(0.6),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => setState(() => _activeModal = null),
                        child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(100)), child: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 20)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_activeModal == 'stock') ...[
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 20), SizedBox(width: 8), Text('OUT OF STOCK MANAGEMENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), letterSpacing: 3.0))])),
                      const SizedBox(height: 16),
                      Text('Branch Availability for ${_selectedProduct?.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                    ] else if (_activeModal == 'discount') ...[
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.local_offer, color: Color(0xFF10B981), size: 20), SizedBox(width: 8), Text('FIXED DISCOUNT MANAGER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF10B981), letterSpacing: 3.0))])),
                      const SizedBox(height: 16),
                      const Text('Set Discount Price', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                    ] else if (_activeModal == 'promo') ...[
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.confirmation_number, color: Color(0xFFF59E0B), size: 20), SizedBox(width: 8), Text('COUPON CODE MANAGER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFF59E0B), letterSpacing: 3.0))])),
                      const SizedBox(height: 16),
                      const Text('Create Promo Code', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                    ] else if (_activeModal == 'global-promo') ...[
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.percent, color: Color(0xFFF97316), size: 20), SizedBox(width: 8), Text('STORE-WIDE CAMPAIGN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFF97316), letterSpacing: 3.0))])),
                      const SizedBox(height: 16),
                      const Text('Apply to All Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
