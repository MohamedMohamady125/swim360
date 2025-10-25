import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketplaceItem {
  final String id;
  final String title;
  final double price;
  final String photo;
  final String description;
  final String condition;
  final String size;
  final String contact;
  final String userId;
  bool isSold;
  final List<String> photos;

  MarketplaceItem({
    required this.id,
    required this.title,
    required this.price,
    required this.photo,
    required this.description,
    required this.condition,
    required this.size,
    required this.contact,
    required this.userId,
    this.isSold = false,
    this.photos = const [],
  });
}

class MarketplaceFilters {
  String searchTerm;
  String? condition;
  String? size;
  double? maxPrice;

  MarketplaceFilters({
    this.searchTerm = '',
    this.condition,
    this.size,
    this.maxPrice,
  });

  MarketplaceFilters copyWith({
    String? searchTerm,
    String? condition,
    String? size,
    double? maxPrice,
  }) {
    return MarketplaceFilters(
      searchTerm: searchTerm ?? this.searchTerm,
      condition: condition ?? this.condition,
      size: size ?? this.size,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}

class UsedScreen extends StatefulWidget {
  const UsedScreen({Key? key}) : super(key: key);

  @override
  State<UsedScreen> createState() => _UsedScreenState();
}

class _UsedScreenState extends State<UsedScreen> with SingleTickerProviderStateMixin {
  static const String currentUserId = 'user123';
  
  String currentView = 'home';
  String? selectedItemId;
  MarketplaceFilters filters = MarketplaceFilters();
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  
  String _selectedCondition = 'New';
  String _selectedSize = 'M';

  List<MarketplaceItem> items = [
    MarketplaceItem(
      id: 'item1',
      title: 'Speedo Fastskin LZR Racer',
      price: 299.99,
      photo: 'https://placehold.co/400x300/1e40af/ffffff?text=LZR+Suit',
      description: 'Elite racing suit, used once. Hydrodynamic compression.',
      condition: 'Excellent',
      size: 'M',
      contact: '966512345678',
      userId: 'user123',
      isSold: false,
      photos: ['https://placehold.co/400x300/1e40af/ffffff?text=LZR+Suit+1', 'https://placehold.co/400x300/1e40af/ffffff?text=LZR+Suit+2'],
    ),
    MarketplaceItem(
      id: 'item2',
      title: 'Zoggs Predator Goggles',
      price: 15.00,
      photo: 'https://placehold.co/400x300/06b6d4/ffffff?text=Goggles',
      description: 'Good condition, anti-fog coating still strong. Blue lenses.',
      condition: 'Good',
      size: 'One Size',
      contact: '966598765432',
      userId: 'user456',
      isSold: false,
      photos: ['https://placehold.co/400x300/06b6d4/ffffff?text=Goggles+1'],
    ),
    MarketplaceItem(
      id: 'item3',
      title: 'Arena Powerfin Pro',
      price: 35.50,
      photo: 'https://placehold.co/400x300/0f766e/ffffff?text=Fins',
      description: 'Size L training fins. Great for leg power and ankle flexibility.',
      condition: 'Fair',
      size: 'L',
      contact: '966511122233',
      userId: 'user123',
      isSold: false,
      photos: ['https://placehold.co/400x300/0f766e/ffffff?text=Fins+1', 'https://placehold.co/400x300/0f766e/ffffff?text=Fins+2', 'https://placehold.co/400x300/0f766e/ffffff?text=Fins+3'],
    ),
    MarketplaceItem(
      id: 'item4',
      title: 'FINIS Snorkel',
      price: 25.00,
      photo: 'https://placehold.co/400x300/22c55e/ffffff?text=Snorkel',
      description: 'Excellent centre-mount snorkel, clear tube. Used lightly.',
      condition: 'Excellent',
      size: 'S',
      contact: '966554433221',
      userId: 'user789',
      isSold: true,
      photos: ['https://placehold.co/400x300/22c55e/ffffff?text=Snorkel+1'],
    ),
    MarketplaceItem(
      id: 'item5',
      title: 'Water Polo Ball',
      price: 50.00,
      photo: 'https://placehold.co/400x300/f97316/ffffff?text=Ball',
      description: 'Official size 5 water polo ball. Barely used.',
      condition: 'New',
      size: 'M',
      contact: '966512345678',
      userId: 'user123',
      isSold: false,
      photos: ['https://placehold.co/400x300/f97316/ffffff?text=Ball+1', 'https://placehold.co/400x300/f97316/ffffff?text=Ball+2'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _searchController.addListener(_onSearchChanged);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animations = List.generate(6, (index) {
      double start = (index * 0.1).clamp(0.0, 1.0);
      double end = (start + 0.3).clamp(start, 1.0);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      filters = filters.copyWith(searchTerm: _searchController.text);
    });
  }

  void _navigate(String view, [String? itemId]) {
    setState(() {
      currentView = view;
      selectedItemId = itemId;
    });
  }

  List<MarketplaceItem> get filteredItems {
    return items.where((item) {
      if (item.isSold) return false;
      if (filters.searchTerm.isNotEmpty && 
          !item.title.toLowerCase().contains(filters.searchTerm.toLowerCase())) {
        return false;
      }
      if (filters.condition != null && item.condition != filters.condition) {
        return false;
      }
      if (filters.size != null && item.size != filters.size) {
        return false;
      }
      if (filters.maxPrice != null && item.price > filters.maxPrice!) {
        return false;
      }
      return true;
    }).toList();
  }

  List<MarketplaceItem> get myItems {
    return items.where((item) => item.userId == currentUserId).toList();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: _buildCurrentView(),
      ),
      floatingActionButton: currentView == 'home' ? _buildFABs() : null,
    );
  }

  Widget _buildCurrentView() {
    switch (currentView) {
      case 'details':
        return _buildItemDetailView();
      case 'sell':
        return _buildSellItemForm();
      case 'my-items':
        return _buildMyItemsView();
      default:
        return _buildHomeView();
    }
  }

  Widget _buildFABs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "my-items",
          backgroundColor: Colors.amber,
          onPressed: () => _navigate('my-items'),
          child: const Icon(Icons.shopping_bag, color: Colors.white),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: "sell-item",
          backgroundColor: Colors.teal,
          onPressed: () => _navigate('sell'),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildHomeView() {
    final filtered = filteredItems;
    
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Used Swimming Gear',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _showFilterDialog,
                    icon: const Icon(Icons.filter_list),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _resetFilters,
                    child: const Text('Reset'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Items Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No items found.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _animations[index % _animations.length],
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animations[index % _animations.length].value,
                            child: Opacity(
                              opacity: _animations[index % _animations.length].value,
                              child: _buildItemCard(filtered[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(MarketplaceItem item) {
    return GestureDetector(
      onTap: () => _navigate('details', item.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  item.photo,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('No Image', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: filters.condition,
              decoration: const InputDecoration(labelText: 'Condition'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All Conditions')),
                DropdownMenuItem(value: 'New', child: Text('New')),
                DropdownMenuItem(value: 'Excellent', child: Text('Excellent')),
                DropdownMenuItem(value: 'Good', child: Text('Good')),
                DropdownMenuItem(value: 'Fair', child: Text('Fair')),
              ],
              onChanged: (value) {
                setState(() {
                  filters = filters.copyWith(condition: value);
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: filters.size,
              decoration: const InputDecoration(labelText: 'Size'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All Sizes')),
                DropdownMenuItem(value: 'XS', child: Text('XS')),
                DropdownMenuItem(value: 'S', child: Text('S')),
                DropdownMenuItem(value: 'M', child: Text('M')),
                DropdownMenuItem(value: 'L', child: Text('L')),
                DropdownMenuItem(value: 'XL', child: Text('XL')),
                DropdownMenuItem(value: 'One Size', child: Text('One Size')),
              ],
              onChanged: (value) {
                setState(() {
                  filters = filters.copyWith(size: value);
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Max Price (\$)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final price = double.tryParse(value);
                setState(() {
                  filters = filters.copyWith(maxPrice: price);
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      filters = MarketplaceFilters();
      _searchController.clear();
    });
  }
  Widget _buildItemDetailView() {
    final item = items.firstWhere((i) => i.id == selectedItemId);
    
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.photos.isNotEmpty ? item.photos[0] : item.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('No Image', style: TextStyle(color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title and Price
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                // Condition and Size
                Wrap(
                  spacing: 16,
                  children: [
                    Chip(
                      label: Text('Condition: ${item.condition}'),
                      backgroundColor: Colors.grey[200],
                    ),
                    Chip(
                      label: Text('Size: ${item.size}'),
                      backgroundColor: Colors.grey[200],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 24),
                // Contact Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchWhatsApp(item),
                    icon: const Icon(Icons.message, color: Colors.white),
                    label: const Text(
                      'Contact Seller (WhatsApp)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellItemForm() {
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 16),
              const Text(
                'Sell Your Item',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Form
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: const InputDecoration(
                    labelText: 'Condition',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'New', child: Text('New')),
                    DropdownMenuItem(value: 'Excellent', child: Text('Excellent')),
                    DropdownMenuItem(value: 'Good', child: Text('Good')),
                    DropdownMenuItem(value: 'Fair', child: Text('Fair')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSize,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'XS', child: Text('XS')),
                    DropdownMenuItem(value: 'S', child: Text('S')),
                    DropdownMenuItem(value: 'M', child: Text('M')),
                    DropdownMenuItem(value: 'L', child: Text('L')),
                    DropdownMenuItem(value: 'XL', child: Text('XL')),
                    DropdownMenuItem(value: 'One Size', child: Text('One Size')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text('Add up to 10 photos'),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement photo picker
                          _showSnackBar('Photo picker not implemented yet');
                        },
                        child: const Text('Choose Photos'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _postItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Post Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildMyItemsView() {
    final myItemsList = myItems;
    
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 16),
              const Text(
                'My Posted Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Items List
        Expanded(
          child: myItemsList.isEmpty
              ? const Center(
                  child: Text(
                    'You have no posted items.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myItemsList.length,
                  itemBuilder: (context, index) {
                    final item = myItemsList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.isSold ? 'Sold' : 'Available',
                                    style: TextStyle(
                                      color: item.isSold ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _toggleSoldStatus(item.id),
                                  icon: Icon(
                                    item.isSold ? Icons.refresh : Icons.check,
                                    color: item.isSold ? Colors.blue : Colors.green,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: item.isSold 
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => _confirmDelete(item.id),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.red.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _postItem() {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _contactController.text.isEmpty) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    final newItem = MarketplaceItem(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descriptionController.text,
      contact: _contactController.text,
      condition: _selectedCondition,
      size: _selectedSize,
      photo: 'https://placehold.co/400x300/cccccc/ffffff?text=New+Item',
      photos: [],
      userId: currentUserId,
      isSold: false,
    );

    setState(() {
      items.add(newItem);
    });

    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _contactController.clear();

    _showSnackBar('Item posted successfully!');
    _navigate('home');
  }

  void _launchWhatsApp(MarketplaceItem item) async {
    final message = Uri.encodeComponent('Is this item still available? (Item: ${item.title})');
    final url = Uri.parse('https://wa.me/${item.contact}?text=$message');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showSnackBar('Could not launch WhatsApp', isError: true);
    }
  }

  void _toggleSoldStatus(String itemId) {
    showDialog(
      context: context,
      builder: (context) {
        final item = items.firstWhere((i) => i.id == itemId);
        final actionText = item.isSold ? 'mark as Available' : 'mark as Sold';
        
        return AlertDialog(
          title: const Text('Confirm Status Change'),
          content: Text('Are you sure you want to $actionText this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  item.isSold = !item.isSold;
                });
                Navigator.of(context).pop();
                _showSnackBar('Item marked as ${item.isSold ? 'Sold' : 'Available'}.');
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this item? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                items.removeWhere((item) => item.id == itemId);
              });
              Navigator.of(context).pop();
              _showSnackBar('Item deleted successfully.');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

