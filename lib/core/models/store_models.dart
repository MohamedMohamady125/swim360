// ============================================
// STORE DETAILS MODEL
// ============================================

class StoreDetails {
  final String userId;
  final String storeName;
  final String? description;
  final String? websiteUrl;
  final String? licenseNumber;
  final bool shippingAvailable;
  final bool acceptsReturns;
  final int returnPolicyDays;
  final double rating;
  final int totalReviews;
  final int totalSales;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreDetails({
    required this.userId,
    required this.storeName,
    this.description,
    this.websiteUrl,
    this.licenseNumber,
    this.shippingAvailable = true,
    this.acceptsReturns = true,
    this.returnPolicyDays = 30,
    required this.rating,
    required this.totalReviews,
    required this.totalSales,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreDetails.fromJson(Map<String, dynamic> json) {
    return StoreDetails(
      userId: json['user_id'],
      storeName: json['store_name'],
      description: json['description'],
      websiteUrl: json['website_url'],
      licenseNumber: json['license_number'],
      shippingAvailable: json['shipping_available'] ?? true,
      acceptsReturns: json['accepts_returns'] ?? true,
      returnPolicyDays: json['return_policy_days'] ?? 30,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      totalSales: json['total_sales'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'description': description,
      'website_url': websiteUrl,
      'license_number': licenseNumber,
      'shipping_available': shippingAvailable,
      'accepts_returns': acceptsReturns,
      'return_policy_days': returnPolicyDays,
    };
  }
}

// ============================================
// STORE BRANCH MODEL
// ============================================

class StoreBranch {
  final String id;
  final String userId;
  final String locationName;
  final String? governorate;
  final String? city;
  final String? locationUrl;
  final String? branchPhone;
  final String? openingHour;
  final String? openingMinute;
  final String? openingAmpm;
  final String? closingHour;
  final String? closingMinute;
  final String? closingAmpm;
  final List<String>? deliveryOptions;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreBranch({
    required this.id,
    required this.userId,
    required this.locationName,
    this.governorate,
    this.city,
    this.locationUrl,
    this.branchPhone,
    this.openingHour,
    this.openingMinute,
    this.openingAmpm,
    this.closingHour,
    this.closingMinute,
    this.closingAmpm,
    this.deliveryOptions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreBranch.fromJson(Map<String, dynamic> json) {
    return StoreBranch(
      id: json['id'],
      userId: json['user_id'],
      locationName: json['location_name'],
      governorate: json['governorate'],
      city: json['city'],
      locationUrl: json['location_url'],
      branchPhone: json['branch_phone'],
      openingHour: json['opening_hour'],
      openingMinute: json['opening_minute'],
      openingAmpm: json['opening_ampm'],
      closingHour: json['closing_hour'],
      closingMinute: json['closing_minute'],
      closingAmpm: json['closing_ampm'],
      deliveryOptions: json['delivery_options'] != null
          ? List<String>.from(json['delivery_options'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_name': locationName,
      'governorate': governorate,
      'city': city,
      'location_url': locationUrl,
      'branch_phone': branchPhone,
      'opening_hour': openingHour,
      'opening_minute': openingMinute,
      'opening_ampm': openingAmpm,
      'closing_hour': closingHour,
      'closing_minute': closingMinute,
      'closing_ampm': closingAmpm,
      'delivery_options': deliveryOptions,
    };
  }
}

// ============================================
// STORE PRODUCT MODEL
// ============================================

class StoreProduct {
  final String id;
  final String userId;
  final String name;
  final String? brand;
  final String? category;
  final double price;
  final String? description;
  final List<String>? availableSizes;
  final List<String>? availableColors;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreProduct({
    required this.id,
    required this.userId,
    required this.name,
    this.brand,
    this.category,
    required this.price,
    this.description,
    this.availableSizes,
    this.availableColors,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    return StoreProduct(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      brand: json['brand'],
      category: json['category'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      availableSizes: json['available_sizes'] != null
          ? List<String>.from(json['available_sizes'])
          : null,
      availableColors: json['available_colors'] != null
          ? List<String>.from(json['available_colors'])
          : null,
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'description': description,
      'available_sizes': availableSizes,
      'available_colors': availableColors,
      'photo_url': photoUrl,
    };
  }
}

// ============================================
// ORDER ITEM MODEL
// ============================================

class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String? productBrand;
  final String? selectedSize;
  final String? selectedColor;
  final double unitPrice;
  final int quantity;
  final double subtotal;
  final DateTime createdAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.productBrand,
    this.selectedSize,
    this.selectedColor,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    required this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productBrand: json['product_brand'],
      selectedSize: json['selected_size'],
      selectedColor: json['selected_color'],
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_brand': productBrand,
      'selected_size': selectedSize,
      'selected_color': selectedColor,
      'unit_price': unitPrice,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

// ============================================
// STORE ORDER MODEL
// ============================================

class StoreOrder {
  final int id;
  final String? userId;
  final String storeOwnerId;
  final String status;
  final double totalAmount;
  final String? customerName;
  final String? customerPhone;
  final String? deliveryAddress;
  final String? deliveryType;
  final String? branchId;
  final DateTime? deliveryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem>? items;

  StoreOrder({
    required this.id,
    this.userId,
    required this.storeOwnerId,
    required this.status,
    required this.totalAmount,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.deliveryType,
    this.branchId,
    this.deliveryDate,
    required this.createdAt,
    required this.updatedAt,
    this.items,
  });

  factory StoreOrder.fromJson(Map<String, dynamic> json) {
    return StoreOrder(
      id: json['id'],
      userId: json['user_id'],
      storeOwnerId: json['store_owner_id'],
      status: json['status'] ?? 'pending',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      deliveryAddress: json['delivery_address'],
      deliveryType: json['delivery_type'],
      branchId: json['branch_id'],
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: json['items'] != null
          ? (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'delivery_type': deliveryType,
      'branch_id': branchId,
    };

    if (items != null) {
      map['items'] = items!.map((item) => item.toJson()).toList();
    }

    return map;
  }
}

// ============================================
// USED ITEM (MARKETPLACE) MODEL
// ============================================

class UsedItem {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final String category;
  final String? brand;
  final String condition;
  final double price;
  final String currency;
  final bool isNegotiable;
  final String? size;
  final String? color;
  final int? yearPurchased;
  final List<String>? photos;
  final String contactPhone;
  final String? contactWhatsapp;
  final String? preferredContactMethod;
  final String? city;
  final String? governorate;
  final bool isSold;
  final bool isActive;
  final int viewCount;
  final DateTime? soldAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UsedItem({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.category,
    this.brand,
    required this.condition,
    required this.price,
    this.currency = 'USD',
    this.isNegotiable = true,
    this.size,
    this.color,
    this.yearPurchased,
    this.photos,
    required this.contactPhone,
    this.contactWhatsapp,
    this.preferredContactMethod,
    this.city,
    this.governorate,
    this.isSold = false,
    this.isActive = true,
    this.viewCount = 0,
    this.soldAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UsedItem.fromJson(Map<String, dynamic> json) {
    return UsedItem(
      id: json['id'],
      sellerId: json['seller_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      brand: json['brand'],
      condition: json['condition'],
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      isNegotiable: json['is_negotiable'] ?? true,
      size: json['size'],
      color: json['color'],
      yearPurchased: json['year_purchased'],
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : null,
      contactPhone: json['contact_phone'],
      contactWhatsapp: json['contact_whatsapp'],
      preferredContactMethod: json['preferred_contact_method'],
      city: json['city'],
      governorate: json['governorate'],
      isSold: json['is_sold'] ?? false,
      isActive: json['is_active'] ?? true,
      viewCount: json['view_count'] ?? 0,
      soldAt: json['sold_at'] != null
          ? DateTime.parse(json['sold_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'brand': brand,
      'condition': condition,
      'price': price,
      'currency': currency,
      'is_negotiable': isNegotiable,
      'size': size,
      'color': color,
      'year_purchased': yearPurchased,
      'photos': photos,
      'contact_phone': contactPhone,
      'contact_whatsapp': contactWhatsapp,
      'preferred_contact_method': preferredContactMethod,
      'city': city,
      'governorate': governorate,
    };
  }
}
