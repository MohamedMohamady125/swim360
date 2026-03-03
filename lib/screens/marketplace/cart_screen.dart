import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  final double _serviceFee = 2.50;
  double _discountPercent = 0;
  String? _promoMessage;
  bool _promoSuccess = false;

  List<CartItem> _cartItems = [];

  double get _subtotal => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get _discountAmount => _subtotal * (_discountPercent / 100);
  double get _total => (_subtotal + _serviceFee) - _discountAmount;

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    setState(() {
      if (code == 'SWIM10') {
        _discountPercent = 10;
        _promoMessage = '10% Discount Applied!';
        _promoSuccess = true;
      } else {
        _discountPercent = 0;
        _promoMessage = 'Invalid Code';
        _promoSuccess = false;
      }
    });
  }

  void _updateQuantity(String id, int change) {
    setState(() {
      final item = _cartItems.firstWhere((i) => i.id == id);
      item.quantity += change;
      if (item.quantity < 1) {
        _removeItem(id);
      }
    });
  }

  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((i) => i.id == id);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _discountPercent = 0;
      _promoMessage = null;
      _promoController.clear();
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _cartItems.isEmpty ? _buildEmptyState() : _buildCartContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MY CART', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                  Text(
                    _cartItems.isEmpty ? 'ITEMS SELECTED' : '${_cartItems.length} ITEMS SELECTED',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 2.5),
                  ),
                ],
              ),
            ],
          ),
          if (_cartItems.isNotEmpty)
            InkWell(
              onTap: _clearCart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('CLEAR ALL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), letterSpacing: 2.5)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ..._cartItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCartItem(item),
          )),
          const SizedBox(height: 24),
          _buildPromoSection(),
          const SizedBox(height: 24),
          _buildSummarySection(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(item.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name.toUpperCase(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                      ),
                    ),
                    InkWell(
                      onTap: () => _removeItem(item.id),
                      child: const Icon(Icons.delete_outline, color: Color(0xFF9CA3AF), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.brand} • ${item.size}'.toUpperCase(),
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 2.5),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => _updateQuantity(item.id, -1),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(child: Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                          ),
                          InkWell(
                            onTap: () => _updateQuantity(item.id, 1),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(child: Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_offer, color: Color(0xFF2563EB), size: 16),
              SizedBox(width: 8),
              Text('OFFERS & COUPONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'SWIM10',
                    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _applyPromo,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)],
                  ),
                  child: const Text('APPLY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
                ),
              ),
            ],
          ),
          if (_promoMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _promoMessage!,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _promoSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444), letterSpacing: 2.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 20))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ORDER SUMMARY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),
          _buildSummaryRow('SUBTOTAL', '\$${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildSummaryRow('DELIVERY FEES', 'FREE', valueColor: const Color(0xFF10B981)),
          const SizedBox(height: 12),
          _buildSummaryRow('SERVICE FEES', '\$${_serviceFee.toStringAsFixed(2)}'),
          if (_discountAmount > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow('DISCOUNT (10%)', '-\$${_discountAmount.toStringAsFixed(2)}', valueColor: const Color(0xFF2563EB)),
          ],
          const SizedBox(height: 24),
          Container(
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                  const SizedBox(height: 4),
                  Text('\$${_total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                ],
              ),
              InkWell(
                onTap: () {
                  // Navigate to checkout
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Text('CHECKOUT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: valueColor ?? const Color(0xFF111827))),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF93C5FD), size: 48),
          ),
          const SizedBox(height: 24),
          const Text('CART IS EMPTY', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20)],
              ),
              child: const Text('START SHOPPING', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String size;
  final String color;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.size,
    required this.color,
    required this.quantity,
    required this.image,
  });
}
