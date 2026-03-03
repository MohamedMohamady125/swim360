// ============================================
// ACADEMY DETAILS MODEL
// ============================================

class AcademyDetails {
  final String userId;
  final String academyName;
  final String? description;
  final String? websiteUrl;
  final String? licenseNumber;
  final int? establishedYear;
  final int totalCoaches;
  final int totalStudents;
  final double rating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  AcademyDetails({
    required this.userId,
    required this.academyName,
    this.description,
    this.websiteUrl,
    this.licenseNumber,
    this.establishedYear,
    required this.totalCoaches,
    required this.totalStudents,
    required this.rating,
    required this.totalReviews,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AcademyDetails.fromJson(Map<String, dynamic> json) {
    return AcademyDetails(
      userId: json['user_id'],
      academyName: json['academy_name'],
      description: json['description'],
      websiteUrl: json['website_url'],
      licenseNumber: json['license_number'],
      establishedYear: json['established_year'],
      totalCoaches: json['total_coaches'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'academy_name': academyName,
      'description': description,
      'website_url': websiteUrl,
      'license_number': licenseNumber,
      'established_year': establishedYear,
    };
  }
}

// ============================================
// ACADEMY BRANCH MODEL
// ============================================

class AcademyBranch {
  final String id;
  final String userId;
  final String name;
  final String? city;
  final String? governorate;
  final String? locationUrl;
  final String? openingTime;
  final String? closingTime;
  final List<String>? operatingDays;
  final DateTime createdAt;
  final DateTime updatedAt;

  AcademyBranch({
    required this.id,
    required this.userId,
    required this.name,
    this.city,
    this.governorate,
    this.locationUrl,
    this.openingTime,
    this.closingTime,
    this.operatingDays,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AcademyBranch.fromJson(Map<String, dynamic> json) {
    return AcademyBranch(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      city: json['city'],
      governorate: json['governorate'],
      locationUrl: json['location_url'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      operatingDays: json['operating_days'] != null
          ? List<String>.from(json['operating_days'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'governorate': governorate,
      'location_url': locationUrl,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'operating_days': operatingDays,
    };
  }
}

// ============================================
// ACADEMY POOL MODEL
// ============================================

class AcademyPool {
  final String id;
  final String branchId;
  final String name;
  final int lanes;
  final int capacity;
  final DateTime createdAt;

  AcademyPool({
    required this.id,
    required this.branchId,
    required this.name,
    required this.lanes,
    required this.capacity,
    required this.createdAt,
  });

  factory AcademyPool.fromJson(Map<String, dynamic> json) {
    return AcademyPool(
      id: json['id'],
      branchId: json['branch_id'],
      name: json['name'],
      lanes: json['lanes'] ?? 6,
      capacity: json['capacity'] ?? 30,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'name': name,
      'lanes': lanes,
      'capacity': capacity,
    };
  }
}

// ============================================
// ACADEMY PROGRAM MODEL
// ============================================

class AcademyProgram {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final double price;
  final String? duration;
  final int capacity;
  final int enrolled;
  final DateTime createdAt;
  final DateTime updatedAt;

  AcademyProgram({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.price,
    this.duration,
    required this.capacity,
    required this.enrolled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AcademyProgram.fromJson(Map<String, dynamic> json) {
    return AcademyProgram(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'],
      capacity: json['capacity'] ?? 20,
      enrolled: json['enrolled'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'capacity': capacity,
    };
  }
}

// ============================================
// ACADEMY SWIMMER MODEL
// ============================================

class AcademySwimmer {
  final String id;
  final String userId;
  final String swimmerName;
  final String? phone;
  final String? programId;
  final String? branchId;
  final DateTime? endDate;
  final DateTime createdAt;

  AcademySwimmer({
    required this.id,
    required this.userId,
    required this.swimmerName,
    this.phone,
    this.programId,
    this.branchId,
    this.endDate,
    required this.createdAt,
  });

  factory AcademySwimmer.fromJson(Map<String, dynamic> json) {
    return AcademySwimmer(
      id: json['id'],
      userId: json['user_id'],
      swimmerName: json['swimmer_name'],
      phone: json['phone'],
      programId: json['program_id'],
      branchId: json['branch_id'],
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'swimmer_name': swimmerName,
      'phone': phone,
      'program_id': programId,
      'branch_id': branchId,
      'end_date': endDate?.toIso8601String(),
    };
  }
}

// ============================================
// ACADEMY COACH MODEL
// ============================================

class AcademyCoach {
  final String id;
  final String academyId;
  final String? branchId;
  final String fullName;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String? specialization;
  final int? experienceYears;
  final List<String>? certifications;
  final String? bio;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AcademyCoach({
    required this.id,
    required this.academyId,
    this.branchId,
    required this.fullName,
    this.email,
    this.phone,
    this.photoUrl,
    this.specialization,
    this.experienceYears,
    this.certifications,
    this.bio,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AcademyCoach.fromJson(Map<String, dynamic> json) {
    return AcademyCoach(
      id: json['id'],
      academyId: json['academy_id'],
      branchId: json['branch_id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
      specialization: json['specialization'],
      experienceYears: json['experience_years'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      bio: json['bio'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'photo_url': photoUrl,
      'specialization': specialization,
      'experience_years': experienceYears,
      'certifications': certifications,
      'bio': bio,
    };
  }
}
