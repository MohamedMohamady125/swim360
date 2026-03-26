import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swim360/core/services/event_service.dart';

class MyAttendeesScreen extends StatefulWidget {
  const MyAttendeesScreen({super.key});

  @override
  State<MyAttendeesScreen> createState() => _MyAttendeesScreenState();
}

class _MyAttendeesScreenState extends State<MyAttendeesScreen> {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _loadingEvents = true;
  bool _loadingAttendees = false;

  final Map<String, List<Attendee>> _attendees = {};

  String? _selectedEventId;
  String _searchTerm = '';
  String? _activeModal;
  Attendee? _selectedAttendee;
  String? _notification;
  String _notificationType = 'success';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final models = await _eventService.getMyEvents();
      if (mounted) {
        setState(() {
          _events = models.map((m) => Event(
            id: m.id,
            name: m.eventName,
            date: '${m.eventDate.year}-${m.eventDate.month.toString().padLeft(2, '0')}-${m.eventDate.day.toString().padLeft(2, '0')}',
          )).toList();
          _loadingEvents = false;
          if (_events.isNotEmpty) {
            _selectedEventId = _events.first.id;
            _fetchRegistrations(_events.first.id);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingEvents = false);
        _showNotify('Failed to load events: ${e.toString().replaceAll('Exception: ', '')}', 'error');
      }
    }
  }

  Future<void> _fetchRegistrations(String eventId) async {
    if (_attendees.containsKey(eventId)) return;
    setState(() => _loadingAttendees = true);
    try {
      final regs = await _eventService.getEventRegistrations(eventId);
      if (mounted) {
        setState(() {
          _attendees[eventId] = regs.map((r) {
            final name = r['full_name'] ?? r['email'] ?? 'Unknown';
            return Attendee(
              id: r['user_id'] ?? r['id'] ?? '',
              name: name,
              age: 0,
              phone: r['phone_number'] ?? '',
              ticket: 'Standard',
              avatar: name.isNotEmpty ? name[0].toUpperCase() : '?',
            );
          }).toList();
          _loadingAttendees = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingAttendees = false);
        _showNotify('Failed to load registrations: ${e.toString().replaceAll('Exception: ', '')}', 'error');
      }
    }
  }

  void _showNotify(String msg, [String type = 'success']) {
    setState(() {
      _notification = msg;
      _notificationType = type;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _notification = null);
      }
    });
  }

  List<Attendee> get _filteredAttendees {
    if (_selectedEventId == null) return [];
    final roster = _attendees[_selectedEventId] ?? [];
    return roster.where((a) => a.name.toLowerCase().contains(_searchTerm.toLowerCase())).toList();
  }

  Event? get _selectedEvent {
    if (_selectedEventId == null || _events.isEmpty) return null;
    try {
      return _events.firstWhere((e) => e.id == _selectedEventId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll('+', '');
    final url = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFF3F4F6)),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: const Icon(Icons.arrow_back, size: 24),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Attendees', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                              SizedBox(height: 2),
                              Text('ROSTER MANAGEMENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFECDD3)),
                        ),
                        child: const Icon(Icons.emoji_events, color: Color(0xFFE11D48), size: 24),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Filters Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('SELECTED EVENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            InkWell(
                              onTap: () {
                                // PDF export would go here
                                _showNotify("PDF export feature - not implemented in this demo");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.download, size: 12, color: Color(0xFF2563EB)),
                                    SizedBox(width: 4),
                                    Text('PDF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 2.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_loadingEvents)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
                          )
                        else if (_events.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('No events found', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
                          )
                        else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.emoji_events, color: Color(0xFF9CA3AF), size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedEventId,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                  items: _events.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedEventId = value!;
                                      _searchTerm = '';
                                    });
                                    _fetchRegistrations(value!);
                                  },
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: (value) => setState(() => _searchTerm = value),
                          decoration: InputDecoration(
                            hintText: 'Search attendee name...',
                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 16),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Attendees List
                  Row(
                    children: [
                      Text('${_filteredAttendees.length} REGISTERED', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFD1D5DB), letterSpacing: 3.0)),
                      const SizedBox(width: 16),
                      const Expanded(child: Divider(color: Color(0xFFF3F4F6))),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (_loadingAttendees)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
                    )
                  else if (_filteredAttendees.isNotEmpty)
                    ..._filteredAttendees.map((attendee) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => setState(() {
                          _selectedAttendee = attendee;
                          _activeModal = 'details';
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFFECDD3)),
                                  boxShadow: [BoxShadow(color: const Color(0xFFE11D48).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                                ),
                                child: Center(
                                  child: Text(attendee.avatar, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFE11D48))),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(attendee.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.confirmation_number, size: 12, color: Color(0xFF2563EB)),
                                        const SizedBox(width: 6),
                                        Text(attendee.ticket.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.visibility, color: Color(0xFF9CA3AF), size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(Icons.people_outline, size: 40, color: Color(0xFFE5E7EB)),
                          ),
                          const SizedBox(height: 16),
                          const Text('NO MATCHING ATTENDEES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Details Modal
          if (_activeModal != null && _selectedAttendee != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _activeModal = null),
                child: Container(
                  color: const Color(0xFF0F172A).withOpacity(0.6),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () => setState(() => _activeModal = null),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 20),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: const Color(0xFFFECDD3)),
                                boxShadow: [BoxShadow(color: const Color(0xFFE11D48).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: const Icon(Icons.person, color: Color(0xFFE11D48), size: 40),
                            ),

                            const SizedBox(height: 16),

                            Text(_selectedAttendee!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text((_selectedEvent?.name ?? '').toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),

                            const SizedBox(height: 24),

                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('AGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                      Text('${_selectedAttendee!.age} Years', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Divider(height: 24, color: Color(0xFFE5E7EB)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('TICKET TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                      Text(_selectedAttendee!.ticket, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE11D48))),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            InkWell(
                              onTap: () => _launchWhatsApp(_selectedAttendee!.phone),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF25D366),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [BoxShadow(color: const Color(0xFF25D366).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble, color: Colors.white, size: 24),
                                    SizedBox(width: 12),
                                    Text('WHATSAPP CHAT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            InkWell(
                              onTap: () => setState(() => _activeModal = null),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Dismiss', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Notification
          if (_notification != null)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: _notificationType == 'error' ? const Color(0xFFDC2626) : const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_notificationType == 'success' ? Icons.check_circle : Icons.error, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(_notification!.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Event {
  final String id;
  final String name;
  final String date;

  Event({required this.id, required this.name, required this.date});
}

class Attendee {
  final String id;
  final String name;
  final int age;
  final String phone;
  final String ticket;
  final String avatar;

  Attendee({
    required this.id,
    required this.name,
    required this.age,
    required this.phone,
    required this.ticket,
    required this.avatar,
  });
}
