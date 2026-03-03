import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final List<String> _eventTypes = ["Championship", "Clinic", "Seminar", "Zoom Meeting", "Fun Swim", "Training", "Other"];
  final List<String> _audiences = ["Swimmers", "Nutritionists", "Doctors", "Parents", "Coaches", "Other"];

  List<Event> _events = [];

  String _view = 'list'; // 'list', 'edit', 'details'
  Event? _editingEvent;
  String? _notification;
  String _notificationType = 'success';
  bool _loading = false;

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

  String _formatTime24to12(String time24) {
    if (time24.isEmpty) return '';
    final parts = time24.split(':');
    int hr = int.parse(parts[0]);
    final min = parts[1];
    final ampm = hr >= 12 ? 'PM' : 'AM';
    hr = hr % 12;
    if (hr == 0) hr = 12;
    return '${hr.toString().padLeft(2, '0')}:$min $ampm';
  }

  void _handleEditClick(Event event) {
    setState(() {
      _editingEvent = Event(
        id: event.id,
        name: event.name,
        date: event.date,
        time: event.time,
        durationValue: event.durationValue,
        durationUnit: event.durationUnit,
        price: event.price,
        tickets: event.tickets,
        locationName: event.locationName,
        locationUrl: event.locationUrl,
        ageRange: event.ageRange,
        targetAudience: event.targetAudience,
        type: event.type,
        description: event.description,
        videoUrl: event.videoUrl,
        photoUrl: event.photoUrl,
      );
      _view = 'edit';
    });
  }

  void _handleDetailsClick(Event event) {
    setState(() {
      _editingEvent = event;
      _view = 'details';
    });
  }

  void _handleSave() {
    if (_editingEvent!.name.isEmpty || _editingEvent!.locationName.isEmpty || _editingEvent!.tickets == 0) {
      _showNotify("Please fill in all required fields", "error");
      return;
    }

    setState(() => _loading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _events = _events.map((ev) => ev.id == _editingEvent!.id ? _editingEvent! : ev).toList();
          _loading = false;
          _showNotify("Event details updated successfully!");
          _view = 'list';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: _view == 'list'
                ? _buildListView()
                : _view == 'edit'
                    ? _buildEditView()
                    : _buildDetailsView(),
          ),
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

  Widget _buildListView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Events', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Manage and promote your upcoming listings', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 32),
          ..._events.map((event) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFF9FAFB),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.network(event.photoUrl, width: 80, height: 80, fit: BoxFit.cover),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFFDEEFFF)),
                              ),
                              child: Text(event.type, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 4),
                            Text('${event.date} • ${_formatTime24to12(event.time)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(event.price == 0 ? 'FREE' : '\$${event.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                            const SizedBox(width: 12),
                            const Text('|', style: TextStyle(color: Color(0xFFE5E7EB))),
                            const SizedBox(width: 12),
                            const Icon(Icons.location_on, size: 12, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(event.locationName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () => _handleDetailsClick(event),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.visibility, color: Color(0xFF9CA3AF), size: 20),
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => _handleEditClick(event),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.edit, color: Color(0xFF2563EB), size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEditView() {
    return Column(
      children: [
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
                  InkWell(
                    onTap: () => setState(() => _view = 'list'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF6B7280)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: Text(_editingEvent!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              InkWell(
                onTap: _loading ? null : _handleSave,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Text(_loading ? 'SAVING...' : 'UPDATE', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
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
                          Text('EVENT INFORMATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Event Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(_editingEvent!.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF6B7280))),
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
                          value: _editingEvent!.type,
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                          items: _eventTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                          onChanged: (value) => setState(() => _editingEvent!.type = value!),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: _editingEvent!.description),
                        onChanged: (value) => _editingEvent!.description = value,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      const Text('Promo Video URL (Optional)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: _editingEvent!.videoUrl),
                        onChanged: (value) => _editingEvent!.videoUrl = value,
                        decoration: InputDecoration(
                          hintText: 'https://...',
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
                          Text('TIME & LOCATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Date', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: TextEditingController(text: _editingEvent!.date),
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
                                      initialDate: DateTime.parse(_editingEvent!.date),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
                                    );
                                    if (date != null) {
                                      setState(() => _editingEvent!.date = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
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
                                const Text('Time', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: TextEditingController(text: _editingEvent!.time),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                  readOnly: true,
                                  onTap: () async {
                                    final parts = _editingEvent!.time.split(':');
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
                                    );
                                    if (time != null) {
                                      setState(() => _editingEvent!.time = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                                    }
                                  },
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
                        controller: TextEditingController(text: _editingEvent!.locationName),
                        onChanged: (value) => _editingEvent!.locationName = value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      const Text('Google Maps URL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: _editingEvent!.locationUrl),
                        onChanged: (value) => _editingEvent!.locationUrl = value,
                        decoration: InputDecoration(
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
                          Text('AUDIENCE & PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Price (\$)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text('\$${_editingEvent!.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
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
                                  controller: TextEditingController(text: _editingEvent!.ageRange),
                                  onChanged: (value) => _editingEvent!.ageRange = value,
                                  decoration: InputDecoration(
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
                        child: DropdownButton<String>(
                          value: _editingEvent!.targetAudience,
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                          items: _audiences.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                          onChanged: (value) => setState(() => _editingEvent!.targetAudience = value!),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => _view = 'list'),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.chevron_left, size: 24, color: Color(0xFF6B7280)),
                ),
              ),
              const Text('Event Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(width: 40),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Stack(
                      children: [
                        Image.network(_editingEvent!.photoUrl, width: double.infinity, height: 240, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.6)],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE11D48),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(_editingEvent!.type, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                              ),
                              const SizedBox(height: 8),
                              Text(_editingEvent!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Color(0xFFE11D48), size: 24),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('DATE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                const SizedBox(height: 4),
                                Text(_editingEvent!.date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFF2563EB), size: 24),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('START TIME', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                const SizedBox(height: 4),
                                Text(_formatTime24to12(_editingEvent!.time), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('ABOUT THE EVENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Text(_editingEvent!.description, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.6)),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ENTRY FEE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                          Text('\$${_editingEvent!.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AUDIENCE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blue.shade200, letterSpacing: 3.0)),
                                const SizedBox(height: 4),
                                Text(_editingEvent!.targetAudience, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CAPACITY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blue.shade200, letterSpacing: 3.0)),
                                const SizedBox(height: 4),
                                Text('${_editingEvent!.tickets} Tickets Total', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    // Open maps URL
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF60A5FA), size: 20),
                        SizedBox(width: 12),
                        Text('OPEN VENUE IN MAPS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Event {
  String id;
  String name;
  String date;
  String time;
  String durationValue;
  String durationUnit;
  double price;
  int tickets;
  String locationName;
  String locationUrl;
  String ageRange;
  String targetAudience;
  String type;
  String description;
  String videoUrl;
  String photoUrl;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.durationValue,
    required this.durationUnit,
    required this.price,
    required this.tickets,
    required this.locationName,
    required this.locationUrl,
    required this.ageRange,
    required this.targetAudience,
    required this.type,
    required this.description,
    required this.videoUrl,
    required this.photoUrl,
  });
}
