import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swim360/core/services/store_service.dart';
import 'package:swim360/core/models/store_models.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final StoreApiService _storeService = StoreApiService();

  String _orderTab = 'pending'; // 'pending', 'confirmed', 'delivered'
  String _branchFilter = 'all';
  String _orderSearch = '';
  String? _activeModal;
  StoreOrder? _selectedOrder;

  List<StoreOrder> _orders = [];
  List<StoreBranch> _branches = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final orders = await _storeService.getMyOrders();
      final branches = await _storeService.getMyBranches();

      if (mounted) {
        setState(() {
          _orders = orders;
          _branches = branches;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<StoreOrder> get filteredOrders {
    return _orders.where((order) {
      final matchesStatus = order.status == _orderTab;
      final matchesBranch = _branchFilter == 'all' || order.branchId == _branchFilter;
      final matchesSearch = _orderSearch.isEmpty || order.id.toString().contains(_orderSearch);
      return matchesStatus && matchesBranch && matchesSearch;
    }).toList();
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: const Color(0xFF1F2937)),
    );
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = Uri.parse('https://wa.me/${phone.replaceAll('+', '')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading && _orders.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading orders...'),
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
                  onPressed: _loadData,
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
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text('Order Management', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                const SizedBox(height: 4),
                const Text('Process and track your store sales', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
                const SizedBox(height: 32),

                // Branch Filter
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Store Branch', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.business, color: Color(0xFF9CA3AF), size: 16),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButton<String>(
                                value: _branchFilter,
                                isExpanded: true,
                                underline: const SizedBox(),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                items: [
                                  const DropdownMenuItem(value: 'all', child: Text('All Branches')),
                                  ..._branches.map((b) => DropdownMenuItem(value: b.id, child: Text(b.locationName))),
                                ],
                                onChanged: (val) => setState(() => _branchFilter = val!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order Tabs
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: ['pending', 'confirmed', 'delivered'].map((tab) {
                      final isActive = _orderTab == tab;
                      return Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _orderTab = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isActive ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))] : [],
                            ),
                            child: Text(
                              tab == 'delivered' ? 'ARCHIVE' : tab.toUpperCase(),
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isActive ? Colors.white : const Color(0xFF9CA3AF), letterSpacing: 3.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Orders List
                ...filteredOrders.map((order) {
                  final borderColor = _orderTab == 'pending' ? const Color(0xFFF59E0B) : _orderTab == 'confirmed' ? const Color(0xFF10B981) : const Color(0xFF2563EB);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border(
                          left: BorderSide(width: 8, color: borderColor),
                          top: const BorderSide(color: Color(0xFFF3F4F6)),
                          right: const BorderSide(color: Color(0xFFF3F4F6)),
                          bottom: const BorderSide(color: Color(0xFFF3F4F6)),
                        ),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order #${order.id}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                                  const SizedBox(height: 4),
                                  Text((order.deliveryType ?? 'PICKUP').toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                ],
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  _selectedOrder = order;
                                  _activeModal = 'details';
                                }),
                                child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.visibility, color: Color(0xFF2563EB), size: 20)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.shopping_bag, color: Color(0xFFD1D5DB), size: 16),
                              const SizedBox(width: 8),
                              Text('${order.items?.length ?? 0} Items', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF6B7280))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFD1D5DB), size: 16),
                              const SizedBox(width: 8),
                              Expanded(child: Text(order.deliveryAddress ?? 'N/A', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
                            ],
                          ),
                          if (order.deliveryDate != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Color(0xFF10B981), size: 16),
                                const SizedBox(width: 8),
                                Text('Expected: ${DateFormat('MMM d, yyyy').format(order.deliveryDate!)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (order.status == 'pending') ...[
                                InkWell(
                                  onTap: () async {
                                    try {
                                      setState(() => _isLoading = true);
                                      await _storeService.updateOrderStatus(order.id, {'status': 'cancelled'});
                                      await _loadData();
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                        _showNotification('Order rejected');
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                        _showNotification('Failed to reject order: $e');
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)),
                                    child: const Text('REJECT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), letterSpacing: 3.0)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () async {
                                    try {
                                      setState(() => _isLoading = true);
                                      await _storeService.updateOrderStatus(order.id, {'status': 'confirmed'});
                                      await _loadData();
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                        _showNotification('Order confirmed');
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                        _showNotification('Failed to confirm order: $e');
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]),
                                    child: const Text('CONFIRM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                                  ),
                                ),
                              ] else if (order.status == 'confirmed') ...[
                                InkWell(
                                  onTap: () => setState(() {
                                    _selectedOrder = order;
                                    _activeModal = 'contact';
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
                                    child: const Row(children: [Icon(Icons.chat, color: Color(0xFF10B981), size: 14), SizedBox(width: 6), Text('CONTACT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF10B981), letterSpacing: 3.0))]),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () async {
                                    try {
                                      setState(() => _isLoading = true);
                                      await _storeService.updateOrderStatus(order.id, {'status': 'delivered'});
                                      await _loadData();
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                        _showNotification('Order marked as delivered');
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                        _showNotification('Failed to mark as delivered: $e');
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]),
                                    child: const Row(children: [Icon(Icons.check_circle, color: Colors.white, size: 14), SizedBox(width: 6), Text('DELIVERED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0))]),
                                  ),
                                ),
                              ] else ...[
                                InkWell(
                                  onTap: () => setState(() {
                                    _selectedOrder = order;
                                    _activeModal = 'contact';
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                                    child: const Row(children: [Icon(Icons.chat, color: Color(0xFF6B7280), size: 14), SizedBox(width: 6), Text('CONTACT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF6B7280), letterSpacing: 3.0))]),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (_activeModal != null) _buildModal(),
        ],
      ),
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
                    if (_activeModal == 'details') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order Items', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                          InkWell(onTap: () => setState(() => _activeModal = null), child: const Icon(Icons.close, color: Color(0xFF9CA3AF))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...(_selectedOrder?.items ?? []).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(item.productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                              Text('x${item.quantity}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                            ],
                          ),
                        ),
                      )),
                    ] else if (_activeModal == 'contact') ...[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(30)),
                        child: const Icon(Icons.chat, color: Color(0xFF10B981), size: 40),
                      ),
                      const SizedBox(height: 16),
                      const Text('Chat with Customer', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                      const SizedBox(height: 8),
                      Text('Connect via WhatsApp for Order #${_selectedOrder?.id}', style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () => _launchWhatsApp(_selectedOrder?.customerPhone ?? ''),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: const Color(0xFF25D366).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.phone, color: Colors.white, size: 24), SizedBox(width: 12), Text('START WHATSAPP CHAT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0))],
                          ),
                        ),
                      ),
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
