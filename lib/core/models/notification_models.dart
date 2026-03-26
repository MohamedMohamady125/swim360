class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final String? actionUrl;
  final String? relatedId;
  final String? relatedType;
  final bool isRead;
  final String? readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.actionUrl,
    this.relatedId,
    this.relatedType,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      actionUrl: json['action_url'],
      relatedId: json['related_id'],
      relatedType: json['related_type'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
