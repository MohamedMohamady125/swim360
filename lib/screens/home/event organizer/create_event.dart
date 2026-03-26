import 'package:flutter/material.dart';
import 'package:swim360/core/services/event_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final EventService _eventService = EventService();
  final List<String> _eventTypes = ["Championship", "Clinic", "Seminar", "Zoom Meeting", "Fun Swim", "Training", "Other"];
  final List<String> _audiences = ["Swimmers", "Nutritionists", "Doctors", "Parents", "Coaches", "Other"];

  String? _notification;
  String _notificationType = 'success';
  bool _loading = false;

  // Form fields
  String _name = '';
  String _type = 'Championship';
  String _description = '';
  String _date = '';
  String _time = '';
  String _durationValue = '';
  String _durationUnit = 'hours';
  String _tickets = '';
  String _locationName = '';
  String _locationUrl = '';
  String _price = '';
  String _ageRange = '';
  String _targetAudience = 'Swimmers';
  String _videoUrl = '';

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

  static const Map<String, String> _typeToBackend = {
    'Championship': 'competition',
    'Seminar': 'seminar',
    'Zoom Meeting': 'webinar',
    'Training': 'training_camp',
    'Fun Swim': 'meet',
    'Clinic': 'workshop',
    'Other': 'meet',
  };

  Future<void> _handleSubmit() async {
    if (_name.isEmpty || _price.isEmpty || _locationName.isEmpty || _tickets.isEmpty) {
      _showNotify("Please fill in all required fields.", "error");
      return;
    }

    setState(() => _loading = true);

    try {
      final eventData = <String, dynamic>{
        'event_name': _name,
        'event_type': _typeToBackend[_type] ?? 'meet',
        'description': _description.isNotEmpty ? _description : _name,
        'event_date': _date.isNotEmpty ? _date : DateTime.now().toIso8601String().split('T')[0],
        'start_time': _time.isNotEmpty ? _time : '09:00',
        'venue_name': _locationName,
        'address': _locationUrl,
        'max_participants': int.tryParse(_tickets) ?? 100,
        'registration_fee': double.tryParse(_price) ?? 0.0,
        'is_online': false,
      };

      await _eventService.createEvent(eventData);

      if (mounted) {
        _showNotify("Event Published Successfully!");
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showNotify("Failed to create event: ${e.toString().replaceAll('Exception: ', '')}", "error");
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Post Event', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                              SizedBox(height: 2),
                              Text('NEW LISTING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 24),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // 1. Event Details & Media Section
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
                              const Row(
                                children: [
                                  Icon(Icons.grid_view, size: 16, color: Color(0xFF2563EB)),
                                  SizedBox(width: 8),
                                  Text('DETAILS & MEDIA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                ],
                              ),

                              const SizedBox(height: 20),

                              const Text('Event Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              TextField(
                                onChanged: (value) => setState(() => _name = value),
                                decoration: InputDecoration(
                                  hintText: 'e.g. Regional Championship 2026',
                                  hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                  filled: true,
                                  fillColor: const Color(0xFFF9FAFB),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),

                              const SizedBox(height: 16),

                              const Text('Event Type', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: DropdownButton<String>(
                                  value: _type,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                  items: _eventTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                  onChanged: (value) => setState(() => _type = value!),
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text('Cover Photo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.camera_alt, color: Color(0xFF3B82F6), size: 32),
                                    SizedBox(height: 8),
                                    Text('UPLOAD IMAGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text('Promo Video URL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              TextField(
                                onChanged: (value) => setState(() => _videoUrl = value),
                                decoration: InputDecoration(
                                  hintText: 'Paste YouTube or Vimeo link...',
                                  hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                  filled: true,
                                  fillColor: const Color(0xFFF9FAFB),
                                  prefixIcon: const Icon(Icons.videocam, color: Color(0xFFD1D5DB), size: 16),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),

                              const SizedBox(height: 16),

                              const Text('Detailed Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              TextField(
                                onChanged: (value) => setState(() => _description = value),
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'Outline the schedule, importance, and requirements...',
                                  hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
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

                        // 2. Time, Location & Capacity Section
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
                              const Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Color(0xFF2563EB)),
                                  SizedBox(width: 8),
                                  Text('TIME & LOCATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Event Date', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        TextField(
                                          onChanged: (value) => setState(() => _date = value),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF9FAFB),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                            contentPadding: const EdgeInsets.all(16),
                                          ),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                          readOnly: true,
                                          onTap: () async {
                                            final date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2030),
                                            );
                                            if (date != null) {
                                              setState(() => _date = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Start Time', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        TextField(
                                          onChanged: (value) => setState(() => _time = value),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF9FAFB),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                            contentPadding: const EdgeInsets.all(16),
                                          ),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                          readOnly: true,
                                          onTap: () async {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (time != null) {
                                              setState(() => _time = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Duration', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: TextField(
                                                onChanged: (value) => setState(() => _durationValue = value),
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: '3',
                                                  hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                                  filled: true,
                                                  fillColor: const Color(0xFFF9FAFB),
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                                  contentPadding: const EdgeInsets.all(16),
                                                ),
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF3F4F6),
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: _durationUnit,
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black),
                                                  items: const [
                                                    DropdownMenuItem(value: 'hours', child: Text('HRS')),
                                                    DropdownMenuItem(value: 'days', child: Text('DAYS')),
                                                    DropdownMenuItem(value: 'mins', child: Text('MINS')),
                                                  ],
                                                  onChanged: (value) => setState(() => _durationUnit = value!),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Seats', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        TextField(
                                          onChanged: (value) => setState(() => _tickets = value),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: '100',
                                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                            filled: true,
                                            fillColor: const Color(0xFFF9FAFB),
                                            prefixIcon: const Icon(Icons.event_seat, color: Color(0xFFD1D5DB), size: 16),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                            contentPadding: const EdgeInsets.all(16),
                                          ),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              const Text('Venue Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              TextField(
                                onChanged: (value) => setState(() => _locationName = value),
                                decoration: InputDecoration(
                                  hintText: 'e.g. Central Pool (NYC)',
                                  hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                  filled: true,
                                  fillColor: const Color(0xFFF9FAFB),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),

                              const SizedBox(height: 16),

                              const Text('Google Maps URL (Venue)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              TextField(
                                onChanged: (value) => setState(() => _locationUrl = value),
                                decoration: InputDecoration(
                                  hintText: 'https://maps.app.goo.gl/...',
                                  hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                  filled: true,
                                  fillColor: const Color(0xFFF9FAFB),
                                  prefixIcon: const Icon(Icons.navigation, color: Color(0xFFD1D5DB), size: 16),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 3. Audience & Pricing Section
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
                              const Row(
                                children: [
                                  Icon(Icons.sell, size: 16, color: Color(0xFF2563EB)),
                                  SizedBox(width: 8),
                                  Text('AUDIENCE & PRICE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Ticket Price (\$)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        TextField(
                                          onChanged: (value) => setState(() => _price = value),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: '45.00',
                                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                            filled: true,
                                            fillColor: const Color(0xFFF9FAFB),
                                            prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF2563EB), size: 16),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                            contentPadding: const EdgeInsets.all(16),
                                          ),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Age Range', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        TextField(
                                          onChanged: (value) => setState(() => _ageRange = value),
                                          decoration: InputDecoration(
                                            hintText: 'e.g. 12-18 or All Ages',
                                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
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
                                ],
                              ),

                              const SizedBox(height: 16),

                              const Text('Primary Audience', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.people, color: Color(0xFFD1D5DB), size: 16),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: _targetAudience,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                        items: _audiences.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                                        onChanged: (value) => setState(() => _targetAudience = value!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Submit Button
                        InkWell(
                          onTap: _loading ? null : _handleSubmit,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _loading ? const Color(0xFFFECDD3) : const Color(0xFFE11D48),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [BoxShadow(color: const Color(0xFFE11D48).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                            ),
                            child: Text(
                              _loading ? 'PUBLISHING...' : 'PUBLISH EVENT',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                      Text(_notification!.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0)),
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
