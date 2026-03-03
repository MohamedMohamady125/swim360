import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:swim360/core/services/clinic_service.dart';
import 'package:swim360/core/models/clinic_models.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ClinicApiService _clinicService = ClinicApiService();

  DateTime _selectedDate = DateTime.now();
  String? _selectedBranchId;
  String? _activeModal; // 'details', 'confirm-cancel'
  ClinicBooking? _selectedBooking;
  String? _notificationMsg;
  String _notificationType = 'success';

  bool _isLoading = false;
  String? _errorMessage;

  List<ClinicBranch> _branches = [];
  List<ClinicBooking> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final branches = await _clinicService.getMyBranches();
      final bookings = await _clinicService.getMyBookings();

      if (mounted) {
        setState(() {
          _branches = branches;
          _bookings = bookings;
          _isLoading = false;

          // Set default branch if available
          if (_branches.isNotEmpty && _selectedBranchId == null) {
            _selectedBranchId = _branches.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showNotification(String msg, [String type = 'success']) {
    setState(() {
      _notificationMsg = msg;
      _notificationType = type;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _notificationMsg = null);
      }
    });
  }

  String _formatDateStr(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getDisplayDate(DateTime date) {
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  String _formatTime24to12(String time24) {
    final parts = time24.split(':');
    int hr = int.parse(parts[0]);
    final min = parts[1];
    final ampm = hr >= 12 ? 'PM' : 'AM';
    hr = hr % 12;
    if (hr == 0) hr = 12;
    return '${hr.toString().padLeft(2, '0')}:$min $ampm';
  }

  List<TimeGroup> get _currentBookings {
    final dateKey = _formatDateStr(_selectedDate);

    // Filter bookings by selected branch and date
    final branchBookings = _bookings.where((booking) {
      return booking.branchId == _selectedBranchId &&
             _formatDateStr(booking.bookingDate) == dateKey;
    }).toList();

    // Group by time
    final Map<String, List<ClinicBooking>> grouped = {};
    for (var booking in branchBookings) {
      grouped.putIfAbsent(booking.bookingTime, () => []).add(booking);
    }

    final sortedTimes = grouped.keys.toList()..sort((a, b) => a.compareTo(b));
    return sortedTimes.map((time) => TimeGroup(time: time, bookings: grouped[time]!)).toList();
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  Future<void> _handleCancelBooking() async {
    if (_selectedBooking == null) return;

    try {
      setState(() => _isLoading = true);

      await _clinicService.deleteBooking(_selectedBooking!.id);
      await _loadData(); // Reload data

      if (mounted) {
        setState(() {
          _activeModal = null;
          _selectedBooking = null;
          _isLoading = false;
        });
        _showNotification('Booking for ${_selectedBooking!.clientName} cancelled successfully', 'error');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification('Failed to cancel booking: $e', 'error');
      }
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
    // Show loading state
    if (_isLoading && _bookings.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading bookings...'),
            ],
          ),
        ),
      );
    }

    // Show error state
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
                const SizedBox(height: 16),
                Text(_errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentBookings = _currentBookings;

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
                  const Text('Bookings', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text('Coordinate client sessions and resources', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 24),

                  // Branch & Date Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ACTIVE BRANCH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.business, size: 20, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedBranchId,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                  items: _branches.map((b) => DropdownMenuItem(value: b.id, child: Text(b.locationName))).toList(),
                                  onChanged: (value) => setState(() => _selectedBranchId = value!),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => _changeDate(-1),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF2563EB), size: 20),
                                ),
                              ),
                              Column(
                                children: [
                                  const Text('SCHEDULE FOR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF60A5FA), letterSpacing: 3.0)),
                                  const SizedBox(height: 4),
                                  Text(_getDisplayDate(_selectedDate), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A))),
                                ],
                              ),
                              InkWell(
                                onTap: () => _changeDate(1),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                                  ),
                                  child: const Icon(Icons.arrow_forward, color: Color(0xFF2563EB), size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bookings List
                  if (currentBookings.isNotEmpty)
                    ...currentBookings.map((timeGroup) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                const Expanded(child: Divider(color: Color(0xFFF3F4F6))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(_formatTime24to12(timeGroup.time), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                ),
                                const Expanded(child: Divider(color: Color(0xFFF3F4F6))),
                              ],
                            ),
                          ),
                          ...timeGroup.bookings.map((booking) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                border: const Border(left: BorderSide(color: Color(0xFF10B981), width: 8)),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(booking.clientName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.local_hospital_outlined, size: 12, color: Color(0xFF2563EB)),
                                            const SizedBox(width: 6),
                                            Text(booking.status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            if (booking.bedNumber != null)
                                              Row(
                                                children: [
                                                  const Icon(Icons.layers_outlined, size: 12, color: Color(0xFF9CA3AF)),
                                                  const SizedBox(width: 4),
                                                  Text(booking.bedNumber!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                                                ],
                                              ),
                                            const SizedBox(width: 12),
                                            if (booking.clientAge != null)
                                              Row(
                                                children: [
                                                  const Icon(Icons.person_outline, size: 12, color: Color(0xFF9CA3AF)),
                                                  const SizedBox(width: 4),
                                                  Text('Age: ${booking.clientAge}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedBooking = booking;
                                        _activeModal = 'details';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(Icons.visibility_outlined, color: Color(0xFF2563EB), size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      );
                    })
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
                            child: const Icon(Icons.calendar_today_outlined, size: 40, color: Color(0xFFE5E7EB)),
                          ),
                          const SizedBox(height: 16),
                          const Text('NO BOOKINGS SCHEDULED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Modals
          if (_activeModal != null && _selectedBooking != null)
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
                        child: _activeModal == 'details' ? _buildDetailsModal() : _buildCancelModal(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Notification
          if (_notificationMsg != null)
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
                      Text(_notificationMsg!.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsModal() {
    return Column(
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
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(Icons.person, color: Color(0xFF2563EB), size: 40),
        ),

        const SizedBox(height: 16),

        Text(_selectedBooking!.clientName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(_selectedBooking!.status.toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 3.0)),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(20),
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
                  const Text('APPOINTMENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                  Text(_formatTime24to12(_selectedBooking!.bookingTime), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              if (_selectedBooking!.bedNumber != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ASSIGNED BED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                    Text(_selectedBooking!.bedNumber!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              if (_selectedBooking!.bedNumber != null)
                const SizedBox(height: 12),
              if (_selectedBooking!.clientAge != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('AGE GROUP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                    Text('${_selectedBooking!.clientAge} Years', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        if (_selectedBooking!.phone != null)
          InkWell(
            onTap: () => _launchWhatsApp(_selectedBooking!.phone!),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFF25D366).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('WHATSAPP CHAT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                ],
              ),
            ),
          ),

        if (_selectedBooking!.phone != null)
          const SizedBox(height: 12),

        InkWell(
          onTap: () => setState(() => _activeModal = 'confirm-cancel'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('CANCEL BOOKING', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), letterSpacing: 3.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelModal() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 40),
        ),

        const SizedBox(height: 24),

        const Text('Confirm Deletion', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              children: [
                const TextSpan(text: 'Are you sure you want to cancel the booking for '),
                TextSpan(text: _selectedBooking!.clientName, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                const TextSpan(text: '?'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        InkWell(
          onTap: _handleCancelBooking,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFFDC2626).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: const Text('YES, CANCEL BOOKING', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
          ),
        ),

        const SizedBox(height: 12),

        InkWell(
          onTap: () => setState(() => _activeModal = 'details'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text('Keep Booking', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
          ),
        ),
      ],
    );
  }
}

class TimeGroup {
  final String time;
  final List<ClinicBooking> bookings;

  TimeGroup({required this.time, required this.bookings});
}
