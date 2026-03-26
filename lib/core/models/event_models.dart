class EventModel {
  final String id;
  final String organizerId;
  final String eventName;
  final String eventType;
  final String description;
  final DateTime eventDate;
  final String? startTime;
  final String? endTime;
  final String? venueName;
  final String? address;
  final String? city;
  final String? governorate;
  final double? latitude;
  final double? longitude;
  final bool isOnline;
  final String? onlineMeetingUrl;
  final int? maxParticipants;
  final double registrationFee;
  final DateTime? registrationDeadline;
  final String? coverPhotoUrl;
  final List<String> galleryPhotos;
  final int currentParticipants;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
    required this.id,
    required this.organizerId,
    required this.eventName,
    required this.eventType,
    required this.description,
    required this.eventDate,
    this.startTime,
    this.endTime,
    this.venueName,
    this.address,
    this.city,
    this.governorate,
    this.latitude,
    this.longitude,
    this.isOnline = false,
    this.onlineMeetingUrl,
    this.maxParticipants,
    this.registrationFee = 0,
    this.registrationDeadline,
    this.coverPhotoUrl,
    this.galleryPhotos = const [],
    this.currentParticipants = 0,
    this.isActive = true,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      organizerId: json['organizer_id'],
      eventName: json['event_name'],
      eventType: json['event_type'],
      description: json['description'],
      eventDate: DateTime.parse(json['event_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      venueName: json['venue_name'],
      address: json['address'],
      city: json['city'],
      governorate: json['governorate'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      isOnline: json['is_online'] ?? false,
      onlineMeetingUrl: json['online_meeting_url'],
      maxParticipants: json['max_participants'],
      registrationFee: double.tryParse(json['registration_fee']?.toString() ?? '0') ?? 0.0,
      registrationDeadline: json['registration_deadline'] != null
          ? DateTime.parse(json['registration_deadline'])
          : null,
      coverPhotoUrl: json['cover_photo_url'],
      galleryPhotos: json['gallery_photos'] != null
          ? List<String>.from(json['gallery_photos'])
          : [],
      currentParticipants: json['current_participants'] ?? 0,
      isActive: json['is_active'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  int get seatsLeft => (maxParticipants ?? 0) - currentParticipants;
}
