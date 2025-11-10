import 'package:flutter/material.dart';

class Store {
    final String id;
    final String name;
    final String photo;
    final String location;
    final bool shipping;
    final List<String> categories;
    final List<String> mostSold;

    Store({
        required this.id,
        required this.name,
        required this.photo,
        required this.location,
        required this.shipping,
        required this.categories,
        required this.mostSold,
    });
}

class Product {
    final String id;
    final String name;
    final String size; // display size
    final double price;
    final String brand;
    final String description;
    final List<String> photos;
    final List<String> availableSizes;
    final List<String> availableColors;
    final String? defaultSize;
    final String? defaultColor;

    Product({
        required this.id,
        required this.name,
        required this.size,
        required this.price,
        required this.brand,
        required this.description,
        required this.photos,
        this.availableSizes = const [],
        this.availableColors = const [],
        this.defaultSize,
        this.defaultColor,
    });
}

class CartItem {
    final String productName;
    final String storeName;
    final String? size;
    final String? color;

    CartItem({
        required this.productName,
        required this.storeName,
        this.size,
        this.color,
    });
}

class VariantSelection {
    String? size;
    String? color;
    VariantSelection({this.size, this.color});
}

class StoresScreen extends StatefulWidget {
    const StoresScreen({Key? key}) : super(key: key);

    @override
    State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
    // Views: 'stores-list', 'store-profile', 'store-products', 'product-detail'
    String currentView = 'stores-list';
    String? selectedStoreId;
    String? selectedCategory;
    String? selectedProductName;

    VariantSelection productVariants = VariantSelection();
    List<CartItem> cart = [];

    late final List<Store> stores;
    late final Map<String, Map<String, List<Product>>> storeProducts;

    @override
    void initState() {
        super.initState();
        stores = [
            Store(
                id: 'store1',
                name: 'Swim Gear Pro',
                photo: 'https://placehold.co/100x100/3b82f6/ffffff?text=SGP',
                location: '15.345, 44.567 (Riyadh)',
                shipping: true,
                categories: const ['Suits', 'Goggles', 'Training'],
                mostSold: const ['Pro Racing Suit', 'Mirrored Goggles', 'Kickboard Pro'],
            ),
            Store(
                id: 'store2',
                name: 'Aqua Outlet',
                photo: 'https://placehold.co/100x100/06b6d4/ffffff?text=AO',
                location: '15.123, 44.789 (Jeddah)',
                shipping: false,
                categories: const ['Fins', 'Paddles', 'Snorkels'],
                mostSold: const ['Short Blade Fins'],
            ),
            Store(
                id: 'store3',
                name: 'Triathlon Hub',
                photo: 'https://placehold.co/100x100/ef4444/ffffff?text=TH',
                location: '15.987, 44.321 (Dammam)',
                shipping: true,
                categories: const ['Wetsuits', 'Bags', 'Nutrition'],
                mostSold: const [],
            ),
        ];

        storeProducts = {
            'store1': {
                'Suits': [
                    Product(
                        id: 'p1',
                        name: 'Pro Racing Suit',
                        size: '32',
                        price: 150.00,
                        brand: 'Speedo',
                        description:
                                'Elite FINA-approved suit for competitions. Maximizes hydrodynamics.',
                        photos: const [
                            'https://placehold.co/600x600/1e40af/ffffff?text=SUIT+A',
                            'https://placehold.co/600x600/1e40af/ffffff?text=SUIT+B'
                        ],
                        availableSizes: const ['28', '30', '32', '34'],
                        availableColors: const ['Black', 'Navy', 'Red'],
                        defaultSize: '32',
                        defaultColor: 'Black',
                    ),
                    Product(
                        id: 'p2',
                        name: 'Practice Suit',
                        size: '34',
                        price: 45.00,
                        brand: 'Arena',
                        description:
                                'Durable chlorine-resistant material for daily training sessions.',
                        photos: const [
                            'https://placehold.co/600x600/22c55e/ffffff?text=PRAC+A'
                        ],
                        availableSizes: const ['30', '32', '34', '36'],
                        availableColors: const ['Blue', 'Green'],
                        defaultSize: '34',
                        defaultColor: 'Blue',
                    ),
                ],
                'Goggles': [
                    Product(
                        id: 'p3',
                        name: 'Mirrored Goggles',
                        size: 'Adjustable',
                        price: 25.00,
                        brand: 'Zoggs',
                        description: 'Mirrored lenses reduce glare for outdoor swimming.',
                        photos: const [
                            'https://placehold.co/600x600/f97316/ffffff?text=GOGGLE+A',
                            'https://placehold.co/600x600/f97316/ffffff?text=GOGGLE+B',
                            'https://placehold.co/600x600/f97316/ffffff?text=GOGGLE+C'
                        ],
                        availableSizes: const ['Adjustable'],
                        availableColors: const ['Silver', 'Blue Mirror'],
                        defaultSize: 'Adjustable',
                        defaultColor: 'Silver',
                    ),
                ],
                'Training': [
                    Product(
                        id: 'p4',
                        name: 'Kickboard Pro',
                        size: 'One Size',
                        price: 12.00,
                        brand: 'FINIS',
                        description:
                                'Ergonomic shape for natural body position. Lightweight.',
                        photos: const [
                            'https://placehold.co/600x600/0f766e/ffffff?text=KCK'
                        ],
                        availableSizes: const ['One Size'],
                        availableColors: const ['Yellow', 'Orange'],
                        defaultSize: 'One Size',
                        defaultColor: 'Yellow',
                    ),
                ],
            },
            'store2': {
                'Fins': [
                    Product(
                        id: 'p5',
                        name: 'Short Blade Fins',
                        size: 'Shoe 9',
                        price: 30.00,
                        brand: 'Finis',
                        description:
                                'Ideal for fast tempo kicking and ankle flexibility.',
                        photos: const [
                            'https://placehold.co/600x600/06b6d4/ffffff?text=FINS+1'
                        ],
                        availableSizes: const ['Shoe 7', 'Shoe 8', 'Shoe 9'],
                        availableColors: const ['Blue'],
                        defaultSize: 'Shoe 9',
                        defaultColor: 'Blue',
                    ),
                ],
            },
        };
    }

    // Color mapping similar to original
    static const Map<String, Color> colorMap = {
        'black': Color(0xFF000000),
        'navy': Color(0xFF1d4ed8),
        'red': Color(0xFFef4444),
        'blue': Color(0xFF3b82f6),
        'green': Color(0xFF10b981),
        'silver': Color(0xFF9ca3af),
        'blue mirror': Color(0xFF60a5fa),
        'yellow': Color(0xFFfacc15),
        'orange': Color(0xFFf97316),
    };

    void _navigate(String view,
            {String? id, String? category, String? productName}) {
        setState(() {
            currentView = view;
            selectedStoreId = id;
            selectedCategory = category;
            selectedProductName = productName;
            if (view == 'product-detail') {
                final store = stores.firstWhere((s) => s.id == id);
                final prods = storeProducts[store.id]?[category] ?? [];
                final prod = prods.firstWhere((p) => p.name == productName);
                productVariants = VariantSelection(
                    size: prod.defaultSize,
                    color: prod.defaultColor,
                );
            }
        });
    }

    void _showSnack(String msg, {bool error = false}) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(msg),
                backgroundColor: error ? Colors.red : Colors.green,
                duration: const Duration(seconds: 3),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        final hasBack = currentView != 'stores-list';
        final String title = () {
            switch (currentView) {
                case 'stores-list':
                    return 'Shops & Retailers';
                case 'store-profile':
                    final store = stores.firstWhere((s) => s.id == selectedStoreId);
                    return store.name;
                case 'store-products':
                    return selectedCategory ?? 'Products';
                case 'product-detail':
                    final store = stores.firstWhere((s) => s.id == selectedStoreId);
                    return store.name;
                default:
                    return 'Stores';
            }
        }();

        return Scaffold(
            backgroundColor: const Color(0xFFF7F9FB),
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                leading: hasBack
                        ? IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                                onPressed: () {
                                    if (currentView == 'store-profile') {
                                        _navigate('stores-list');
                                    } else if (currentView == 'store-products') {
                                        _navigate('store-profile', id: selectedStoreId);
                                    } else if (currentView == 'product-detail') {
                                        _navigate('store-products',
                                                id: selectedStoreId, category: selectedCategory);
                                    }
                                },
                            )
                        : null,
                title: Text(title,
                        style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold)),
                centerTitle: false,
            ),
            body: SafeArea(child: _buildCurrentView()),
            floatingActionButton: _buildCartFab(),
        );
    }

    Widget _buildCartFab() {
        return Stack(
            clipBehavior: Clip.none,
            children: [
                FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: _showCartDialog,
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                ),
                if (cart.isNotEmpty)
                    Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                                cart.length.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                        ),
                    ),
            ],
        );
    }

    Widget _buildCurrentView() {
        switch (currentView) {
            case 'stores-list':
                return _buildStoresList();
            case 'store-profile':
                return _buildStoreProfile();
            case 'store-products':
                return _buildStoreProducts();
            case 'product-detail':
                return _buildProductDetail();
            default:
                return _buildStoresList();
        }
    }

    // 1) Stores list
    Widget _buildStoresList() {
        return ListView(
            padding: const EdgeInsets.all(16),
            children: [
                const Text(
                    'Shops & Retailers',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...stores.map((store) => InkWell(
                            onTap: () => _navigate('store-profile', id: store.id),
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                        )
                                    ],
                                ),
                                child: Row(
                                    children: [
                                                            ClipRRect(
                                                                borderRadius: BorderRadius.circular(40),
                                                                child: Image.network(
                                                                    store.photo,
                                                                    width: 64,
                                                                    height: 64,
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (_, __, ___) => Container(
                                                                        width: 64,
                                                                        height: 64,
                                                                        color: Colors.grey.shade300,
                                                                        alignment: Alignment.center,
                                                                        child: const Icon(Icons.store, color: Colors.white70),
                                                                    ),
                                                                ),
                                                            ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(store.name,
                                                            style: const TextStyle(
                                                                    fontSize: 18, fontWeight: FontWeight.bold)),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                        store.shipping
                                                                ? 'Shipping Available'
                                                                : 'Local Pickup Only',
                                                        style: TextStyle(
                                                            color: store.shipping
                                                                    ? Colors.green.shade700
                                                                    : Colors.red.shade500,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 12,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                        const Icon(Icons.chevron_right, color: Colors.grey),
                                    ],
                                ),
                            ),
                        )),
            ],
        );
    }

    // helper to find product details from product name
    ({Product product, String category})? _findProductByName(
            String storeId, String productName) {
        final sp = storeProducts[storeId];
        if (sp == null) return null;
        for (final entry in sp.entries) {
            final prod = entry.value.firstWhere(
                (p) => p.name == productName,
                orElse: () => Product(
                    id: '',
                    name: '',
                    size: '',
                    price: 0,
                    brand: '',
                    description: '',
                    photos: const [],
                ),
            );
            if (prod.id.isNotEmpty) {
                return (product: prod, category: entry.key);
            }
        }
        return null;
    }

    // 2) Store profile
    Widget _buildStoreProfile() {
        final store = stores.firstWhere((s) => s.id == selectedStoreId);
        return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                        )
                    ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            children: [
                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(48),
                                                    child: Image.network(
                                                        store.photo,
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => Container(
                                                            width: 80,
                                                            height: 80,
                                                            color: Colors.grey.shade300,
                                                            alignment: Alignment.center,
                                                            child: const Icon(Icons.store, color: Colors.white70),
                                                        ),
                                                    ),
                                                ),
                                const SizedBox(width: 12),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(store.name,
                                                style: const TextStyle(
                                                        fontSize: 22, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(
                                            store.shipping
                                                    ? 'Shipping Available'
                                                    : 'Local Pickup Only',
                                            style: TextStyle(
                                                color: store.shipping
                                                        ? Colors.green.shade700
                                                        : Colors.red.shade500,
                                                fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Most Sold Items',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: store.mostSold.map((name) {
                                final details = _findProductByName(store.id, name);
                                if (details == null) {
                                    return Chip(
                                        label: Text('$name (Out of Stock)'),
                                        backgroundColor: Colors.grey.shade200,
                                        labelStyle: const TextStyle(color: Colors.grey),
                                    );
                                }
                                return ActionChip(
                                    label: Text(name),
                                    onPressed: () => _navigate('product-detail',
                                            id: store.id,
                                            category: details.category,
                                            productName: details.product.name),
                                    backgroundColor: Colors.blue.shade50,
                                    labelStyle: TextStyle(color: Colors.blue.shade800),
                                );
                            }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text('Browse Categories',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: store.categories
                                    .map((c) => ElevatedButton(
                                                onPressed: () => _navigate('store-products',
                                                        id: store.id, category: c),
                                                style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blue,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10))),
                                                child: Text(c),
                                            ))
                                    .toList(),
                        )
                    ],
                ),
            ),
        );
    }

    // 3) Category products list
    Widget _buildStoreProducts() {
        final store = stores.firstWhere((s) => s.id == selectedStoreId);
        final prods = storeProducts[store.id]?[selectedCategory] ?? [];
        return ListView(
            padding: const EdgeInsets.all(16),
            children: [
                Text('${store.name} - ${selectedCategory ?? ''}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...prods.map((p) => InkWell(
                            onTap: () => _navigate('product-detail',
                                    id: store.id, category: selectedCategory, productName: p.name),
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                        )
                                    ],
                                ),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                                            ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: Image.network(
                                                                    (p.photos.isNotEmpty
                                                                            ? p.photos.first
                                                                            : 'https://placehold.co/100x100/9ca3af/ffffff?text=N%2FA'),
                                                                    width: 56,
                                                                    height: 56,
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (_, __, ___) => Container(
                                                                        width: 56,
                                                                        height: 56,
                                                                        color: Colors.grey.shade300,
                                                                        alignment: Alignment.center,
                                                                        child: const Icon(Icons.image_not_supported,
                                                                                color: Colors.white70, size: 20),
                                                                    ),
                                                                ),
                                                            ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(p.name,
                                                            style: const TextStyle(
                                                                    fontWeight: FontWeight.bold)),
                                                    const SizedBox(height: 2),
                                                    Text('Size: ${p.size}',
                                                            style: const TextStyle(color: Colors.grey)),
                                                ],
                                            ),
                                        ),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                                Text('\$${p.price.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.w600)),
                                                const SizedBox(height: 6),
                                                TextButton(
                                                    onPressed: () => _addToCart(p.name, store.name),
                                                    style: TextButton.styleFrom(
                                                            backgroundColor: Colors.teal,
                                                            foregroundColor: Colors.white,
                                                            minimumSize: const Size(0, 32),
                                                            padding: const EdgeInsets.symmetric(
                                                                    horizontal: 10, vertical: 6),
                                                            shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(16))),
                                                    child: const Text('Add to Cart',
                                                            style: TextStyle(fontSize: 12)),
                                                )
                                            ],
                                        )
                                    ],
                                ),
                            ),
                        ))
            ],
        );
    }

    // 4) Product detail
    Widget _buildProductDetail() {
        final store = stores.firstWhere((s) => s.id == selectedStoreId);
        final prods = storeProducts[store.id]?[selectedCategory] ?? [];
        final product = prods.firstWhere((p) => p.name == selectedProductName);

        final requiresSize = product.availableSizes.isNotEmpty;
        final requiresColor = product.availableColors.isNotEmpty;
        final isSizeSelected = !requiresSize || productVariants.size != null;
        final isColorSelected = !requiresColor || productVariants.color != null;
        final isAddEnabled = isSizeSelected && isColorSelected && store.shipping;

        return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                        )
                    ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(product.name,
                                style: const TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        // Photo gallery
                        if (product.photos.isNotEmpty)
                            GridView.builder(
                                itemCount: product.photos.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                ),
                                                itemBuilder: (context, index) => ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(
                                                        product.photos[index],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => Container(
                                                            color: Colors.grey.shade300,
                                                            alignment: Alignment.center,
                                                            child: const Icon(Icons.image_not_supported,
                                                                    color: Colors.white70),
                                                        ),
                                                    ),
                                                ),
                            )
                        else
                            Container(
                                alignment: Alignment.center,
                                height: 120,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('No photos available.',
                                        style: TextStyle(color: Colors.grey)),
                            ),
                        const SizedBox(height: 12),
                        Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                                children: [
                                    Row(
                                        children: [
                                            const Expanded(
                                                child: Text('Price',
                                                        style: TextStyle(
                                                                color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ),
                                            Text('\$${product.price.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold)),
                                        ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                        children: [
                                            const Expanded(
                                                child: Text('Size',
                                                        style: TextStyle(
                                                                color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ),
                                            Text(product.size,
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                        children: [
                                            const Expanded(
                                                child: Text('Brand',
                                                        style: TextStyle(
                                                                color: Colors.grey, fontWeight: FontWeight.w600)),
                                            ),
                                            Text(product.brand,
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                        const SizedBox(height: 12),
                        // Variant selection
                        if (product.availableSizes.isNotEmpty) ...[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    const Text('Size:',
                                            style:
                                                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text(productVariants.size ?? 'Required',
                                            style: const TextStyle(color: Colors.grey)),
                                ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                                spacing: 8,
                                children: product.availableSizes
                                        .map((s) => ChoiceChip(
                                                    label: Text(s),
                                                    selected: productVariants.size == s,
                                                    onSelected: (_) => setState(() {
                                                        productVariants.size = s;
                                                    }),
                                                ))
                                        .toList(),
                            ),
                            if (!isSizeSelected)
                                const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text('Please select a size.',
                                            style: TextStyle(color: Colors.red, fontSize: 12)),
                                ),
                            const SizedBox(height: 12),
                        ],
                        if (product.availableColors.isNotEmpty) ...[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    const Text('Color:',
                                            style:
                                                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text(productVariants.color ?? 'Required',
                                            style: const TextStyle(color: Colors.grey)),
                                ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: product.availableColors.map((c) {
                                    final color = colorMap[c.toLowerCase()] ?? Colors.grey;
                                    final selected = productVariants.color == c;
                                    return GestureDetector(
                                        onTap: () => setState(() => productVariants.color = c),
                                        child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: selected ? Colors.blue : Colors.transparent,
                                                    width: 3,
                                                ),
                                            ),
                                        ),
                                    );
                                }).toList(),
                            ),
                            if (!isColorSelected)
                                const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text('Please select a color.',
                                            style: TextStyle(color: Colors.red, fontSize: 12)),
                                ),
                            const SizedBox(height: 12),
                        ],
                        const Text('Details',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(product.description, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: isAddEnabled
                                        ? () => _addToCart(product.name, store.name)
                                        : null,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                            store.shipping ? Colors.teal : Colors.grey.shade400,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                    ),
                                ),
                                child: Text(
                                    store.shipping ? 'Add to Cart' : 'Local Pickup Only',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                            ),
                        ),
                        if (!store.shipping)
                            const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Text(
                                    'This item is only available for local pickup.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                            )
                    ],
                ),
            ),
        );
    }

    void _addToCart(String productName, String storeName) {
        final store = stores.firstWhere((s) => s.name == storeName);
        final prods = storeProducts[store.id]?[selectedCategory] ?? [];
        final product = prods.firstWhere((p) => p.name == productName,
                orElse: () => Product(
                            id: '',
                            name: '',
                            size: '',
                            price: 0,
                            brand: '',
                            description: '',
                            photos: const [],
                        ));

        final requiresSize = product.availableSizes.isNotEmpty;
        final requiresColor = product.availableColors.isNotEmpty;
        if ((requiresSize && productVariants.size == null) ||
                (requiresColor && productVariants.color == null)) {
            _showSnack('Please select all required variants (Size/Color).',
                    error: true);
            return;
        }

        if (!store.shipping) {
            _showSnack('Cannot add item. $storeName only offers local pickup.',
                    error: true);
            return;
        }

        final currentCartStore = cart.isNotEmpty ? cart.first.storeName : null;
        if (currentCartStore != null && currentCartStore != storeName) {
            _confirmCartReset(productName, storeName, currentCartStore);
            return;
        }

        setState(() {
            cart.add(CartItem(
                productName: productName,
                storeName: storeName,
                size: productVariants.size,
                color: productVariants.color,
            ));
        });
        _showSnack(
                'Added $productName (Size: ${productVariants.size ?? 'N/A'}, Color: ${productVariants.color ?? 'N/A'}) to cart.');
    }

    void _confirmCartReset(
            String productName, String newStoreName, String oldStoreName) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text('Reset Cart?'),
                content: Text(
                        'Your cart has items from $oldStoreName. To add an item from $newStoreName, your cart must be cleared.'),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                            setState(() {
                                cart = [
                                    CartItem(
                                        productName: productName,
                                        storeName: newStoreName,
                                        size: productVariants.size,
                                        color: productVariants.color,
                                    )
                                ];
                            });
                            Navigator.of(context).pop();
                            _showSnack('Cart reset. Added $productName from $newStoreName.');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Reset & Add',
                                style: TextStyle(color: Colors.white)),
                    )
                ],
            ),
        );
    }

    void _showCartDialog() {
        showDialog(
            context: context,
            builder: (context) {
                return AlertDialog(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            const Text('Shopping Cart'),
                            Container(
                                padding:
                                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('${cart.length} items',
                                        style: const TextStyle(color: Colors.blue)),
                            )
                        ],
                    ),
                    content: SizedBox(
                        width: 320,
                        child: cart.isEmpty
                                ? const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 24),
                                        child:
                                                Center(child: Text('Your cart is empty.', style: TextStyle(color: Colors.grey))),
                                    )
                                : SizedBox(
                                        height: 240,
                                        child: ListView.separated(
                                            itemCount: cart.length,
                                            separatorBuilder: (_, __) => const Divider(height: 12),
                                            itemBuilder: (_, i) {
                                                final item = cart[i];
                                                return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                            child: Text(
                                                                '${item.productName} ${_variantSuffix(item)}',
                                                                style: const TextStyle(fontSize: 13),
                                                                overflow: TextOverflow.ellipsis,
                                                            ),
                                                        ),
                                                        Text('(${item.storeName})',
                                                                style: const TextStyle(
                                                                        fontSize: 11, color: Colors.grey)),
                                                    ],
                                                );
                                            },
                                        ),
                                    ),
                    ),
                    actions: [
                        TextButton(
                            onPressed: cart.isEmpty
                                    ? null
                                    : () {
                                            setState(() => cart.clear());
                                            Navigator.of(context).pop();
                                            _showSnack('Cart cleared.');
                                        },
                            child: const Text('Clear Cart'),
                        ),
                        ElevatedButton(
                            onPressed: cart.isEmpty
                                    ? null
                                    : () {
                                            Navigator.of(context).pop();
                                            _showSnack('Proceeding to payment... (Demo)');
                                        },
                            child: const Text('Proceed to Payment'),
                        ),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                        )
                    ],
                );
            },
        );
    }

    String _variantSuffix(CartItem item) {
        final parts = <String>[];
        if (item.size != null) parts.add(item.size!);
        if (item.color != null) parts.add(item.color!);
        if (parts.isEmpty) return '';
        return '(${parts.join(', ')})';
    }
}

