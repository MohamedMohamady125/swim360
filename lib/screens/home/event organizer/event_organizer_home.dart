import 'package:flutter/material.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/screens/home/event organizer/create_event.dart';
import 'package:swim360/screens/home/event organizer/my_events.dart';
import 'package:swim360/screens/home/event organizer/my_attendees.dart';

class EventOrganizerHomeScreen extends StatefulWidget {
  const EventOrganizerHomeScreen({super.key});

  @override
  State<EventOrganizerHomeScreen> createState() => _EventOrganizerHomeScreenState();
}

class _EventOrganizerHomeScreenState extends State<EventOrganizerHomeScreen> {
  final StorageService _storageService = StorageService();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = await _storageService.getUser();
    if (mounted && user != null) {
      setState(() {
        _userName = user.fullName ?? 'Organizer';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Text('Hello, ${_userName.isNotEmpty ? _userName : 'Organizer'}!', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Event Organizer Dashboard.', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),

              const SizedBox(height: 16),

              // Notifications Banner
              InkWell(
                onTap: () => _showSnackbar(context, 'Navigating to Notifications...', true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('NOTIFICATIONS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                      Icon(Icons.notifications, color: Colors.white, size: 24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Primary Action Banner: CREATE EVENT
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateEventScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('CREATE EVENT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                          SizedBox(width: 8),
                          Text('>', style: TextStyle(fontSize: 24, color: Colors.white)),
                        ],
                      ),
                      Icon(Icons.description, color: Colors.white, size: 40),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Core Action Cards (2x1 Grid)
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'My Events',
                      Icons.event,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyEventsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'My Attendees',
                      Icons.people,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyAttendeesScreen()),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Dynamic Poster/Offers Section
              const Text('Promotional Tools', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildPoster(
                      context,
                      'Create Event',
                      'Set up a new swim meet or clinic.',
                      const Color(0xFFFEE2E2),
                      const Color(0xFFB91C1C),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateEventScreen()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildPoster(
                      context,
                      'Create Offer',
                      'Post a discount code or package deal.',
                      const Color(0xFFFEF3C7),
                      const Color(0xFFA16207),
                      () => _showSnackbar(context, 'Opening Create Offer Form...', false),
                    ),
                    const SizedBox(width: 16),
                    _buildPoster(
                      context,
                      'Advertise',
                      'Promote your brand to our users.',
                      const Color(0xFFDCFCE7),
                      const Color(0xFF15803D),
                      () => _showSnackbar(context, 'Opening Advertising Tools...', false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF3B82F6), size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster(BuildContext context, String title, String subtitle, Color bgColor, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 256,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF374151))),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      ),
    );
  }
}
