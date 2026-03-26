import 'package:flutter/material.dart';
import 'package:swim360/core/services/chat_service.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/core/models/chat_models.dart';
import 'package:swim360/screens/chat/chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final ChatService _chatService = ChatService();
  final StorageService _storageService = StorageService();

  List<Conversation> _conversations = [];
  bool _isLoading = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = await _storageService.getUser();
      _currentUserId = user?.id;

      final conversations = await _chatService.getConversations();

      if (mounted) {
        setState(() {
          _conversations = conversations;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading conversations: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getOtherUserId(Conversation conversation) {
    if (_currentUserId == conversation.participant1Id) {
      return conversation.participant2Id;
    }
    return conversation.participant1Id;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.toUpperCase();
  }

  String _formatTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  void _openChat(Conversation conversation) {
    final otherUserId = _getOtherUserId(conversation);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          conversationId: conversation.id,
          otherUserName: otherUserId,
        ),
      ),
    ).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2563EB),
                ),
              )
            : RefreshIndicator(
                color: const Color(0xFF2563EB),
                onRefresh: _loadData,
                child: _conversations.isEmpty
                    ? _buildEmptyState()
                    : _buildConversationsList(),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'CONVERSATIONS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Color(0xFF9CA3AF),
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 36,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Conversations Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start a conversation with a coach,\nacademy, or clinic.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversationsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'CONVERSATIONS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Color(0xFF9CA3AF),
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 20),
        ..._conversations.map((conversation) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildConversationCard(conversation),
            )),
      ],
    );
  }

  Widget _buildConversationCard(Conversation conversation) {
    final otherUserId = _getOtherUserId(conversation);
    final initials = _getInitials(otherUserId);
    final timeString = _formatTime(conversation.lastMessageAt);
    final preview = conversation.lastMessagePreview ?? 'No messages yet';

    // Generate a consistent color from the user ID
    final colorIndex = otherUserId.hashCode.abs() % _avatarColors.length;
    final avatarColor = _avatarColors[colorIndex];

    return GestureDetector(
      onTap: () => _openChat(conversation),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: avatarColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name and preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserId,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preview,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Time and unread indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeString,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 6),
                if (conversation.lastMessagePreview != null &&
                    conversation.lastMessagePreview!.isNotEmpty)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static const List<Color> _avatarColors = [
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFF059669),
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFF0891B2),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
  ];
}
