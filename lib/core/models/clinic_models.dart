// ============================================
// CLINIC DETAILS MODEL
// ============================================

class ClinicDetails {
  final String userId;
  final String clinicName;
  final String? description;
  final String? websiteUrl;
  final String? licenseNumber;
  final List<String>? specializations;
  final double rating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClinicDetails({
    required this.userId,
    required this.clinicName,
    this.description,
    this.websiteUrl,
    this.licenseNumber,
    this.specializations,
    required this.rating,
    required this.totalReviews,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClinicDetails.fromJson(Map<String, dynamic> json) {
    return ClinicDetails(
      userId: json['user_id'],
      clinicName: json['clinic_name'],
      description: json['description'],
      websiteUrl: json['website_url'],
      licenseNumber: json['license_number'],
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : null,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      totalReviews: json['total_reviews'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic_name': clinicName,
      'description': description,
      'website_url': websiteUrl,
      'license_number': licenseNumber,
      'specializations': specializations,
    };
  }
}

// ============================================
// CLINIC BRANCH MODEL
// ============================================

class ClinicBranch {
  final String id;
  final String userId;
  final String locationName;
  final String? governorate;
  final String? city;
  final String? locationUrl;
  final int numberOfBeds;
  final String? openingHour;
  final String? openingMinute;
  final String? openingAmpm;
  final String? closingHour;
  final String? closingMinute;
  final String? closingAmpm;
  final List<String>? servicesOffered;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClinicBranch({
    required this.id,
    required this.userId,
    required this.locationName,
    this.governorate,
    this.city,
    this.locationUrl,
    required this.numberOfBeds,
    this.openingHour,
    this.openingMinute,
    this.openingAmpm,
    this.closingHour,
    this.closingMinute,
    this.closingAmpm,
    this.servicesOffered,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClinicBranch.fromJson(Map<String, dynamic> json) {
    return ClinicBranch(
      id: json['id'],
      userId: json['user_id'],
      locationName: json['location_name'],
      governorate: json['governorate'],
      city: json['city'],
      locationUrl: json['location_url'],
      numberOfBeds: json['number_of_beds'] ?? 1,
      openingHour: json['opening_hour'],
      openingMinute: json['opening_minute'],
      openingAmpm: json['opening_ampm'],
      closingHour: json['closing_hour'],
      closingMinute: json['closing_minute'],
      closingAmpm: json['closing_ampm'],
      servicesOffered: json['services_offered'] != null
          ? List<String>.from(json['services_offered'])
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
      'number_of_beds': numberOfBeds,
      'opening_hour': openingHour,
      'opening_minute': openingMinute,
      'opening_ampm': openingAmpm,
      'closing_hour': closingHour,
      'closing_minute': closingMinute,
      'closing_ampm': closingAmpm,
      'services_offered': servicesOffered,
    };
  }
}

// ============================================
// CLINIC SERVICE MODEL
// ============================================

class ClinicService {
  final String id;
  final String userId;
  final String title;
  final String? category;
  final double price;
  final String? duration;
  final String? description;
  final String? videoUrl;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClinicService({
    required this.id,
    required this.userId,
    required this.title,
    this.category,
    required this.price,
    this.duration,
    this.description,
    this.videoUrl,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClinicService.fromJson(Map<String, dynamic> json) {
    return ClinicService(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      category: json['category'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      duration: json['duration'],
      description: json['description'],
      videoUrl: json['video_url'],
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'price': price,
      'duration': duration,
      'description': description,
      'video_url': videoUrl,
      'photo_url': photoUrl,
    };
  }
}

// ============================================
// CLINIC BOOKING MODEL
// ============================================

class ClinicBooking {
  final String id;
  final String branchId;
  final String? serviceId;
  final String clientName;
  final int? clientAge;
  final String? phone;
  final DateTime bookingDate;
  final String bookingTime;
  final String? bedNumber;
  final String status;
  final DateTime createdAt;

  ClinicBooking({
    required this.id,
    required this.branchId,
    this.serviceId,
    required this.clientName,
    this.clientAge,
    this.phone,
    required this.bookingDate,
    required this.bookingTime,
    this.bedNumber,
    required this.status,
    required this.createdAt,
  });

  factory ClinicBooking.fromJson(Map<String, dynamic> json) {
    return ClinicBooking(
      id: json['id'],
      branchId: json['branch_id'],
      serviceId: json['service_id'],
      clientName: json['client_name'],
      clientAge: json['client_age'],
      phone: json['phone'],
      bookingDate: DateTime.parse(json['booking_date']),
      bookingTime: json['booking_time'],
      bedNumber: json['bed_number'],
      status: json['status'] ?? 'confirmed',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'service_id': serviceId,
      'client_name': clientName,
      'client_age': clientAge,
      'phone': phone,
      'booking_date': bookingDate.toIso8601String().split('T')[0],
      'booking_time': bookingTime,
      'bed_number': bedNumber,
    };
  }
}
