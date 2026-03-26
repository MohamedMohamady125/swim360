import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swim360/core/services/event_service.dart';
import 'package:swim360/core/models/event_models.dart';

class BookEventScreen extends StatefulWidget {
  const BookEventScreen({super.key});

  @override
  State<BookEventScreen> createState() => _BookEventScreenState();
}

class _BookEventScreenState extends State<BookEventScreen> {
  final EventService _eventService = EventService();

  int _currentStep = 0;
  EventModel? _selectedEvent;
  int _ticketQty = 1;
  bool _isLoading = false;
  String? _errorMessage;

  List<EventModel> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final events = await _eventService.getEvents();

      if (mounted) {
        setState(() {
          _events = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load events: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                _buildStepper(),
                Expanded(child: _buildCurrentStep()),
              ],
            ),
            if (_currentStep == 1 && _selectedEvent != null) _buildFloatingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: _handleBack,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EVENTS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                  Text('MARKETPLACE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                ],
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFE4E6)),
            ),
            child: const Icon(Icons.emoji_events, color: Color(0xFFEF4444), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = ['Explore', 'Details', 'Options'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length, (index) {
          return Row(
            children: [
              _buildStepIndicator(index, steps[index]),
              if (index < steps.length - 1) _buildStepLine(index),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFEF4444) : Colors.white,
            border: Border.all(color: isActive ? const Color(0xFFEF4444) : const Color(0xFFF1F5F9), width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('${step + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isActive ? Colors.white : const Color(0xFF9CA3AF))),
          ),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isActive ? const Color(0xFFEF4444) : const Color(0xFF9CA3AF), letterSpacing: 2.0)),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    return Container(
      width: 50,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: _currentStep > step ? const Color(0xFFEF4444) : const Color(0xFFF1F5F9),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildEventList();
      case 1:
        return _buildEventDetails();
      case 2:
        return _buildTicketQuantity();
      default:
        return const SizedBox();
    }
  }

  Widget _buildEventList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadEvents, child: const Text('Retry')),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _events.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF9CA3AF), size: 16),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Search events...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                  ),
                ],
              ),
            ),
          );
        }

        final event = _events[index - 1];
        final displayDate = '${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}';
        final location = event.venueName ?? event.city ?? 'TBD';
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedEvent = event;
                _currentStep = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 20))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    child: Stack(
                      children: [
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                event.eventType == 'championship' ? const Color(0xFF1D4ED8) : event.eventType == 'fun_swim' ? const Color(0xFFEF4444) : const Color(0xFF059669),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              event.eventType == 'championship' ? Icons.emoji_events : event.eventType == 'fun_swim' ? Icons.pool : Icons.fitness_center,
                              color: Colors.white.withOpacity(0.3),
                              size: 80,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.eventName.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
                              const SizedBox(height: 4),
                              Text(location.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFFECDD3).withOpacity(0.9), letterSpacing: 2.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_today, color: Color(0xFFEF4444), size: 24),
                            ),
                            const SizedBox(width: 8),
                            Text(displayDate.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$${event.registrationFee.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                            const Text('BOOK NOW', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), fontStyle: FontStyle.italic, letterSpacing: 2.5)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventDetails() {
    final startTime = _selectedEvent!.startTime ?? 'TBD';
    final latitude = _selectedEvent!.latitude;
    final longitude = _selectedEvent!.longitude;
    final mapUrl = (latitude != null && longitude != null)
        ? 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude'
        : '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 256,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _selectedEvent!.eventType == 'championship' ? const Color(0xFF1D4ED8) : _selectedEvent!.eventType == 'fun_swim' ? const Color(0xFFEF4444) : const Color(0xFF059669),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _selectedEvent!.eventType == 'championship' ? Icons.emoji_events : _selectedEvent!.eventType == 'fun_swim' ? Icons.pool : Icons.fitness_center,
                    color: Colors.white.withOpacity(0.3),
                    size: 100,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_selectedEvent!.eventType.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), letterSpacing: 2.5)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('ENROLLMENT OPEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF10B981), letterSpacing: 2.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(_selectedEvent!.eventName.toUpperCase(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: mapUrl.isNotEmpty ? () => _launchUrl(mapUrl) : null,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1F2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('LOCATION', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                                    const SizedBox(height: 4),
                                    Text(
                                      mapUrl.isNotEmpty ? 'Open Maps' : (_selectedEvent!.venueName ?? 'Online'),
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.access_time, color: Color(0xFF2563EB), size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('STARTS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                                  const SizedBox(height: 4),
                                  Text(startTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('EVENT DESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3.0)),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 2,
                  color: const Color(0xFFF1F5F9),
                ),
                const SizedBox(height: 16),
                Text(_selectedEvent!.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), height: 1.6)),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketQuantity() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('QUANTITY', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
          const SizedBox(height: 4),
          const Text('ENTRY PASSES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFEF4444), letterSpacing: 2.5)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 20))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Athlete Entry', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        SizedBox(height: 4),
                        Text('STANDARD REGISTRATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic, letterSpacing: 2.5)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => setState(() => _ticketQty = (_ticketQty - 1).clamp(1, 99)),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(child: Text('-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text('$_ticketQty', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          ),
                          InkWell(
                            onTap: () => setState(() => _ticketQty = (_ticketQty + 1).clamp(1, 99)),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(child: Text('+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TOTAL DUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          const SizedBox(height: 4),
                          Text('\$${(_selectedEvent!.registrationFee * _ticketQty).toStringAsFixed(2)}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                        ),
                        child: const Icon(Icons.check, color: Color(0xFF10B981), size: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: () {
              // Navigate to checkout
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('PROCEED TO CHECKOUT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, -10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('SINGLE TICKET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                const SizedBox(height: 4),
                Text('\$${_selectedEvent!.registrationFee.toStringAsFixed(2)}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
              ],
            ),
            InkWell(
              onTap: () => setState(() => _currentStep = 2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: const Text('BUY TICKETS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
