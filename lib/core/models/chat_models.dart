class Conversation {
  final String id;
  final String participant1Id;
  final String participant2Id;
  final String? lastMessageAt;
  final String? lastMessagePreview;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.participant1Id,
    required this.participant2Id,
    this.lastMessageAt,
    this.lastMessagePreview,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      participant1Id: json['participant_1_id'],
      participant2Id: json['participant_2_id'],
      lastMessageAt: json['last_message_at'],
      lastMessagePreview: json['last_message_preview'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String messageText;
  final String? attachmentUrl;
  final String? attachmentType;
  final bool isRead;
  final String? readAt;
  final bool isDeleted;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.messageText,
    this.attachmentUrl,
    this.attachmentType,
    this.isRead = false,
    this.readAt,
    this.isDeleted = false,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      messageText: json['message_text'],
      attachmentUrl: json['attachment_url'],
      attachmentType: json['attachment_type'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'],
      isDeleted: json['is_deleted'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
