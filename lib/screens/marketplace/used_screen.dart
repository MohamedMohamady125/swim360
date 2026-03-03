import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swim360/core/services/store_service.dart';
import 'package:swim360/core/models/store_models.dart';

class UsedScreen extends StatefulWidget {
  const UsedScreen({super.key});

  @override
  State<UsedScreen> createState() => _UsedScreenState();
}

class _UsedScreenState extends State<UsedScreen> {
  final StoreApiService _storeService = StoreApiService();

  String _view = 'home';
  UsedItem? _selectedItem;
  String _searchQuery = '';
  String _activeFilter = 'All';
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String _selectedGovernorate = 'Cairo';
  String _selectedCondition = 'New';
  String _selectedBrand = 'Speedo';
  String _selectedSize = 'Medium (M)';
  String _selectedCategory = 'Goggles';

  List<UsedItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final items = await _storeService.getMarketplaceItems();

      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load items: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<UsedItem> get _filteredItems {
    return _items.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _activeFilter == 'All' || item.condition == _activeFilter;
      return matchesSearch && matchesFilter && item.isActive && !item.isSold;
    }).toList();
  }

  Future<List<UsedItem>> _getMyItems() async {
    try {
      return await _storeService.getMyUsedItems();
    } catch (e) {
      _showNotification('Failed to load your items: $e');
      return [];
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Future<void> _handlePost() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty || _contactController.text.isEmpty) {
      _showNotification('Please fill in required fields');
      return;
    }

    try {
      setState(() => _isLoading = true);

      final data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'governorate': _selectedGovernorate,
        'brand': _selectedBrand,
        'size': _selectedSize,
        'price': double.tryParse(_priceController.text) ?? 0,
        'contact_phone': _contactController.text,
        'photos': ['https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?q=80&w=800&auto=format&fit=crop'],
      };

      await _storeService.createUsedItem(data);
      await _loadItems();

      if (mounted) {
        setState(() {
          _view = 'home';
          _isLoading = false;
        });

        _titleController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _contactController.clear();

        _showNotification('Listing published!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification('Failed to create listing: $e');
      }
    }
  }

  Future<void> _markAsSold(String id) async {
    try {
      setState(() => _isLoading = true);
      await _storeService.updateUsedItem(id, {'is_sold': true});
      await _loadItems();
      _showNotification('Marked as sold');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification('Failed to mark as sold: $e');
      }
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      setState(() => _isLoading = true);
      await _storeService.deleteUsedItem(id);
      await _loadItems();
      _showNotification('Item removed');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification('Failed to delete item: $e');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _buildCurrentView(),
      floatingActionButton: _view == 'home'
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _view = 'sell'),
              backgroundColor: const Color(0xFF2563EB),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('SELL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
            )
          : null,
    );
  }

  Widget _buildCurrentView() {
    switch (_view) {
      case 'home':
        return _buildHome();
      case 'details':
        return _buildDetails();
      case 'sell':
        return _buildSellForm();
      case 'my-items':
        return _buildMyItems();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Marketplace', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                    InkWell(
                      onTap: () => setState(() => _view = 'my-items'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(Icons.list, color: Color(0xFF6B7280), size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search items, brands, or cities...',
                    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'New', 'Excellent', 'Good'].map((filter) {
                      final isActive = _activeFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _activeFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFF2563EB) : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: isActive ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 10)] : null,
                            ),
                            child: Text(filter, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isActive ? Colors.white : const Color(0xFF6B7280))),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return _buildItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(UsedItem item) {
    return InkWell(
      onTap: () => setState(() {
        _selectedItem = item;
        _view = 'details';
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.network((item.photos?.isNotEmpty ?? false) ? item.photos![0] : 'https://via.placeholder.com/400', width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(item.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF9CA3AF), size: 10),
                      const SizedBox(width: 4),
                      Text(item.governorate ?? 'N/A', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 1.0)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    if (_selectedItem == null) return const SizedBox();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          itemCount: _selectedItem!.photos?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              (_selectedItem!.photos?.isNotEmpty ?? false) ? _selectedItem!.photos![index] : 'https://via.placeholder.com/400',
                              fit: BoxFit.cover
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 16,
                        child: InkWell(
                          onTap: () => setState(() => _view = 'home'),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedItem!.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                        const SizedBox(height: 8),
                        Text('\$${_selectedItem!.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                border: Border.all(color: const Color(0xFFDCEEFE)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 16),
                                  const SizedBox(width: 8),
                                  Text((_selectedItem!.governorate ?? 'N/A').toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 2.5)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xFF6B7280), size: 16),
                                  const SizedBox(width: 8),
                                  Text(_selectedItem!.condition.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF6B7280), letterSpacing: 2.5)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('BRAND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                                  Text(_selectedItem!.brand ?? 'N/A', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                                ],
                              ),
                              const Divider(height: 24, color: Color(0xFFF3F4F6)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('SIZE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                                  Text(_selectedItem!.size ?? 'N/A', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('DESCRIPTION', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        const SizedBox(height: 12),
                        Text(_selectedItem!.description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF6B7280), height: 1.6)),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
            ),
            child: InkWell(
              onTap: () => _launchWhatsApp(_selectedItem!.contactPhone),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: const Color(0xFF25D366).withOpacity(0.3), blurRadius: 15)],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text('MESSAGE SELLER', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellForm() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _view = 'home'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('New Listing', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.upload_file, color: Color(0xFF2563EB), size: 40),
                        SizedBox(height: 8),
                        Text('ADD PHOTOS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                        SizedBox(height: 4),
                        Text('Maximum 10 images', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('WHAT ARE YOU SELLING?', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PRICE (\$)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Amount',
                                filled: true,
                                fillColor: Color(0xFFF9FAFB),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CONDITION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedCondition,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF9FAFB),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.all(16),
                              ),
                              items: ['New', 'Excellent', 'Good', 'Fair'].map((condition) {
                                return DropdownMenuItem(value: condition, child: Text(condition));
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedCondition = value!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('GOVERNORATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedGovernorate,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    items: ['Cairo', 'Giza', 'Alexandria', 'Dakahlia'].map((gov) {
                      return DropdownMenuItem(value: gov, child: Text(gov));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedGovernorate = value!),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('BRAND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedBrand,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF9FAFB),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.all(16),
                              ),
                              items: ['Speedo', 'Arena', 'TYR', 'Finis', 'Other'].map((brand) {
                                return DropdownMenuItem(value: brand, child: Text(brand));
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedBrand = value!),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('SIZE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedSize,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF9FAFB),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.all(16),
                              ),
                              items: ['Small (S)', 'Medium (M)', 'Large (L)', 'XL', '26', '28', '30'].map((size) {
                                return DropdownMenuItem(value: size, child: Text(size));
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedSize = value!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('WHATSAPP NUMBER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: '+20',
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('DESCRIPTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Describe the condition, usage, and special features...',
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            InkWell(
              onTap: _handlePost,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20)],
                ),
                child: const Text('PUBLISH LISTING', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyItems() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _view = 'home'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.chevron_left, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('Your Listings', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UsedItem>>(
              future: _getMyItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final myItems = snapshot.data ?? [];

                if (myItems.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No listings yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: myItems.length,
                  itemBuilder: (context, index) {
                    final item = myItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network((item.photos?.isNotEmpty ?? false) ? item.photos![0] : 'https://via.placeholder.com/80', width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.isSold ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  item.isSold ? 'SOLD' : 'AVAILABLE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: item.isSold ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (!item.isSold)
                              InkWell(
                                onTap: () => _markAsSold(item.id),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                                ),
                              ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _deleteItem(item.id),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.delete, color: Color(0xFFEF4444), size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
        ],
      ),
    );
  }
}

