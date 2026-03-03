import 'package:flutter/material.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  String _view = 'home';
  Store? _selectedStore;
  Product? _selectedProduct;
  String? _selectedSize;
  String? _selectedColor;
  String? _sizeGuidePhoto;
  int _photoIndex = 0;

  final List<Store> _stores = [];

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  void _addToCart() {
    if (_selectedProduct!.availableSizes.isNotEmpty && _selectedSize == null) {
      _showNotification('Please select a size');
      return;
    }
    if (_selectedProduct!.availableColors.isNotEmpty && _selectedColor == null) {
      _showNotification('Please select a color');
      return;
    }
    _showNotification('Added ${_selectedProduct!.name} to basket');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          if (_view == 'home') _buildStoresList(),
          if (_view == 'store-profile') _buildStoreProfile(),
          if (_view == 'product-details') _buildProductDetails(),
          if (_sizeGuidePhoto != null) _buildSizeGuideModal(),
        ],
      ),
      floatingActionButton: _view == 'product-details' && _selectedProduct != null
          ? Container(
              width: MediaQuery.of(context).size.width - 64,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text('ADD TO BASKET', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStoresList() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Marketplace', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
            const SizedBox(height: 4),
            const Text('Shop official gear from top retailers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
            const SizedBox(height: 32),
            ..._stores.map((store) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildStoreCard(store),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(Store store) {
    return InkWell(
      onTap: () => setState(() {
        _selectedStore = store;
        _view = 'store-profile';
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: Image.network(store.banner, height: 160, width: double.infinity, fit: BoxFit.cover),
                ),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.8)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(store.photo, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFFfbbf24), size: 12),
                                const SizedBox(width: 4),
                                Text('${store.rating} • ${store.location}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFFbfdbfe).withOpacity(0.9), letterSpacing: 2.5)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text('PICKS:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                  const SizedBox(width: 8),
                  ...store.mostSold.map((tag) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(tag, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreProfile() {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(_selectedStore!.banner, height: 224, width: double.infinity, fit: BoxFit.cover),
              Container(
                height: 224,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              Positioned(
                top: 48,
                left: 20,
                child: InkWell(
                  onTap: () => setState(() => _view = 'home'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                  ),
                ),
              ),
              Positioned(
                bottom: -32,
                left: 32,
                child: Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(_selectedStore!.photo, fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_selectedStore!.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 14),
                                const SizedBox(width: 6),
                                Text(_selectedStore!.location.toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 2.5)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFF10B981), size: 16),
                            const SizedBox(width: 6),
                            Text('${_selectedStore!.rating}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _selectedStore!.categories.map((cat) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(cat.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF6B7280), letterSpacing: 2.5)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ..._selectedStore!.products.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(entry.key.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...entry.value.map((product) => _buildProductCard(product)),
                        const SizedBox(height: 40),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => setState(() {
          _selectedProduct = product;
          _selectedSize = null;
          _selectedColor = null;
          _photoIndex = 0;
          _view = 'product-details';
        }),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(product.photos[0], width: 96, height: 96, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(product.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemCount: _selectedProduct!.photos.length,
                  onPageChanged: (index) => setState(() => _photoIndex = index),
                  itemBuilder: (context, index) {
                    return Image.network(_selectedProduct!.photos[index], fit: BoxFit.cover);
                  },
                ),
              ),
              if (_selectedProduct!.photos.length > 1)
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_selectedProduct!.photos.length, (index) {
                          return Container(
                            width: _photoIndex == index ? 16 : 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: _photoIndex == index ? Colors.white : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 48,
                left: 20,
                child: InkWell(
                  onTap: () => setState(() => _view = 'store-profile'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_selectedProduct!.brand.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 2.5)),
                  ),
                  const SizedBox(height: 8),
                  Text(_selectedProduct!.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                  const SizedBox(height: 8),
                  Text('\$${_selectedProduct!.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: -1.5)),
                  if (_selectedProduct!.availableSizes.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('SELECT SIZE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        if (_selectedProduct!.sizeGuidePhoto != null)
                          InkWell(
                            onTap: () => setState(() => _sizeGuidePhoto = _selectedProduct!.sizeGuidePhoto),
                            child: const Text('Size Guide', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedProduct!.availableSizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return InkWell(
                          onTap: () => setState(() => _selectedSize = size),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 10)] : null,
                            ),
                            child: Text(size, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : const Color(0xFF6B7280))),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (_selectedProduct!.availableColors.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text('AVAILABLE COLORS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _selectedProduct!.availableColors.map((color) {
                        final isSelected = _selectedColor == color.value.toRadixString(16);
                        return InkWell(
                          onTap: () => setState(() => _selectedColor = color.value.toRadixString(16)),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                                width: 4,
                              ),
                              boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 10)] : null,
                            ),
                            child: isSelected ? Icon(Icons.check, color: color == Colors.white ? Colors.black : Colors.white, size: 20) : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 32),
                  const Text('ABOUT THIS ITEM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                  const SizedBox(height: 12),
                  Text(_selectedProduct!.description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF6B7280), height: 1.6)),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeGuideModal() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _sizeGuidePhoto = null),
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                  top: 48,
                  right: 24,
                  child: InkWell(
                    onTap: () => setState(() => _sizeGuidePhoto = null),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        child: Image.network(_sizeGuidePhoto!, fit: BoxFit.contain),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                        ),
                        child: const Text('PINCH TO ZOOM FOR DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () => setState(() => _sizeGuidePhoto = null),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
                    ),
                    child: const Center(
                      child: Text('GOT IT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Store {
  final String id;
  final String name;
  final String photo;
  final String banner;
  final String location;
  final double rating;
  final List<String> categories;
  final List<String> mostSold;
  final Map<String, List<Product>> products;

  Store({
    required this.id,
    required this.name,
    required this.photo,
    required this.banner,
    required this.location,
    required this.rating,
    required this.categories,
    required this.mostSold,
    required this.products,
  });
}

class Product {
  final String id;
  final String name;
  final double price;
  final String brand;
  final String description;
  final List<String> photos;
  final List<String> availableSizes;
  final List<Color> availableColors;
  final String? sizeGuidePhoto;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.brand,
    required this.description,
    required this.photos,
    this.availableSizes = const [],
    this.availableColors = const [],
    this.sizeGuidePhoto,
  });
}
