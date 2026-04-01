import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualBookingScreen extends StatefulWidget {
  const ManualBookingScreen({super.key});

  @override
  State<ManualBookingScreen> createState() => _ManualBookingScreenState();
}

class _ManualBookingScreenState extends State<ManualBookingScreen> {
  DateTime _selectedDate = DateTime(2026, 1, 23);
  String _selectedBranchId = 'b1';
  List<SlotSelection> _selectedSlots = [];
  String? _notificationMsg;
  String _notificationType = 'success';

  final List<Branch> _branches = [];

  Map<String, Map<String, Map<String, List<String>>>> _blockedSlots = {};

  final Map<String, Map<String, Map<String, List<String>>>> _bookedSlots = {};

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

  String _formatTime24to12(String hr24) {
    final hr = int.parse(hr24);
    final ampm = hr >= 12 ? 'PM' : 'AM';
    final displayHr = hr % 12 == 0 ? 12 : hr % 12;
    return '${displayHr.toString().padLeft(2, '0')}:00 $ampm';
  }

  void _changeWeek(int direction) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: direction * 7));
      _selectedSlots.clear();
    });
  }

  void _changeDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlots.clear();
    });
  }

  void _handleSlotTap(String bedId, String time, String type) {
    if (type == 'unavailable' || type == 'booked') return;

    setState(() {
      final selection = SlotSelection(bedId: bedId, time: time);
      if (_selectedSlots.any((s) => s.bedId == bedId && s.time == time)) {
        _selectedSlots.removeWhere((s) => s.bedId == bedId && s.time == time);
      } else {
        _selectedSlots.add(selection);
      }
    });
  }

  void _handleBlock() {
    if (_selectedSlots.isEmpty) return;

    final dateKey = _formatDateStr(_selectedDate);

    setState(() {
      if (_blockedSlots[_selectedBranchId] == null) {
        _blockedSlots[_selectedBranchId] = {};
      }
      if (_blockedSlots[_selectedBranchId]![dateKey] == null) {
        _blockedSlots[_selectedBranchId]![dateKey] = {};
      }

      for (var slot in _selectedSlots) {
        if (_blockedSlots[_selectedBranchId]![dateKey]![slot.bedId] == null) {
          _blockedSlots[_selectedBranchId]![dateKey]![slot.bedId] = [];
        }
        if (!_blockedSlots[_selectedBranchId]![dateKey]![slot.bedId]!.contains(slot.time)) {
          _blockedSlots[_selectedBranchId]![dateKey]![slot.bedId]!.add(slot.time);
        }
      }

      _showNotification('${_selectedSlots.length} slots blocked (Red)', 'error');
      _selectedSlots.clear();
    });
  }

  void _handleFree() {
    if (_selectedSlots.isEmpty) return;

    final dateKey = _formatDateStr(_selectedDate);

    setState(() {
      if (_blockedSlots[_selectedBranchId]?[dateKey] != null) {
        for (var slot in _selectedSlots) {
          _blockedSlots[_selectedBranchId]![dateKey]![slot.bedId]?.remove(slot.time);
        }
      }

      _showNotification('${_selectedSlots.length} slots freed up (White)');
      _selectedSlots.clear();
    });
  }

  Branch? get _selectedBranch {
    if (_branches.isEmpty) return null;
    try {
      return _branches.firstWhere((b) => b.id == _selectedBranchId);
    } catch (e) {
      return _branches.isNotEmpty ? _branches.first : null;
    }
  }

  List<String> get _bedIds {
    final branch = _selectedBranch;
    if (branch == null) return [];
    return List.generate(branch.beds, (i) => 'Bed-${i + 1}');
  }

  List<String> get _timeSlots {
    return List.generate(24, (i) => '${i.toString().padLeft(2, '0')}:00');
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
                            child: const Icon(Icons.calendar_today, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Availability', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.0)),
                              SizedBox(height: 4),
                              Text('BRANCH CAPACITY MANAGEMENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
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

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Branch & Date Card
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
                              const Text('ACTIVE BRANCH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(16),
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
                                        items: _branches.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                                        onChanged: (value) => setState(() => _selectedBranchId = value!),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Week Navigator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () => _changeWeek(-1),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.chevron_left, color: Color(0xFF9CA3AF), size: 20),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMMM yyyy').format(_selectedDate).toUpperCase(),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3.0),
                                  ),
                                  InkWell(
                                    onTap: () => _changeWeek(1),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Day Iterator
                              Row(
                                children: List.generate(7, (i) {
                                  final startOfWeek = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day - _selectedDate.weekday % 7);
                                  final day = startOfWeek.add(Duration(days: i));
                                  final isSelected = _formatDateStr(day) == _formatDateStr(_selectedDate);

                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: InkWell(
                                        onTap: () => _changeDate(day),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF9FAFB),
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))] : [],
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat('E').format(day).toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                                                  letterSpacing: 3.0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                day.day.toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: isSelected ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 24),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.access_time, size: 12, color: Color(0xFF9CA3AF)),
                                  const SizedBox(width: 4),
                                  Text('${_selectedBranch?.open ?? 8}:00 - ${_selectedBranch?.close ?? 20}:00', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.layers, size: 12, color: Color(0xFF9CA3AF)),
                                  const SizedBox(width: 4),
                                  Text('${_selectedBranch?.beds ?? 0} Beds Total', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Legend
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildLegendChip('Free', const Color(0xFFFFFFFF), const Color(0xFFE5E7EB)),
                              const SizedBox(width: 12),
                              _buildLegendChip('Booked', const Color(0xFF10B981), null),
                              const SizedBox(width: 12),
                              _buildLegendChip('Blocked', const Color(0xFFEF4444), null),
                              const SizedBox(width: 12),
                              _buildLegendChip('Closed', const Color(0xFFE5E7EB), null),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Grid
                        _buildGrid(),

                        const SizedBox(height: 24),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: _selectedSlots.isEmpty ? null : _handleBlock,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: _selectedSlots.isEmpty ? const Color(0xFFF3F4F6) : const Color(0xFFEF4444),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: _selectedSlots.isEmpty ? [] : [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.block, color: _selectedSlots.isEmpty ? const Color(0xFFD1D5DB) : Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Text('BLOCK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _selectedSlots.isEmpty ? const Color(0xFFD1D5DB) : Colors.white, letterSpacing: 2.0)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: _selectedSlots.isEmpty ? null : _handleFree,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: _selectedSlots.isEmpty ? const Color(0xFFF3F4F6) : const Color(0xFF2563EB),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: _selectedSlots.isEmpty ? [] : [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh, color: _selectedSlots.isEmpty ? const Color(0xFFD1D5DB) : Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Text('FREE UP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _selectedSlots.isEmpty ? const Color(0xFFD1D5DB) : Colors.white, letterSpacing: 2.0)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (_selectedSlots.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 16),
                              const SizedBox(width: 8),
                              Text('${_selectedSlots.length} SLOTS SELECTED', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
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
                      const Icon(Icons.check_circle, color: Colors.white, size: 16),
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

  Widget _buildLegendChip(String label, Color color, Color? borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final dateKey = _formatDateStr(_selectedDate);
    final branchBlocked = _blockedSlots[_selectedBranchId]?[dateKey] ?? {};
    final branchBooked = _bookedSlots[_selectedBranchId]?[dateKey] ?? {};

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFBFCFD),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  padding: const EdgeInsets.all(12),
                  child: const Text('TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                ),
                ..._bedIds.map((bed) => Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Text(bed.replaceAll('-', ' ').toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF6B7280))),
                  ),
                )),
              ],
            ),
          ),

          // Grid Body
          SizedBox(
            height: 420,
            child: SingleChildScrollView(
              child: Column(
                children: _timeSlots.map((time) {
                  final hour = int.parse(time.split(':')[0]);
                  final isOutside = hour < (_selectedBranch?.open ?? 8) || hour >= (_selectedBranch?.close ?? 20);

                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBFCFD),
                            border: Border(right: BorderSide(color: Color(0xFFF3F4F6))),
                          ),
                          child: Text(_formatTime24to12(time), textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                        ),
                        ..._bedIds.map((bed) {
                          final isBooked = branchBooked[bed]?.contains(time) ?? false;
                          final isBlocked = branchBlocked[bed]?.contains(time) ?? false;
                          final isSelected = _selectedSlots.any((s) => s.bedId == bed && s.time == time);

                          String status = 'available';
                          if (isOutside) status = 'unavailable';
                          else if (isSelected) status = 'selected';
                          else if (isBooked) status = 'booked';
                          else if (isBlocked) status = 'blocked';

                          Color bgColor = Colors.white;
                          if (status == 'unavailable') bgColor = const Color(0xFFF3F4F6);
                          else if (status == 'selected') bgColor = const Color(0xFF3B82F6);
                          else if (status == 'booked') bgColor = const Color(0xFF10B981);
                          else if (status == 'blocked') bgColor = const Color(0xFFEF4444);

                          return Expanded(
                            child: InkWell(
                              onTap: () => _handleSlotTap(bed, time, status),
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  border: const Border(left: BorderSide(color: Color(0xFFF3F4F6))),
                                ),
                                child: Center(
                                  child: status == 'booked'
                                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                                      : status == 'blocked'
                                          ? const Icon(Icons.block, color: Colors.white, size: 16)
                                          : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Branch {
  final String id;
  final String name;
  final int beds;
  final int open;
  final int close;
  final String city;

  Branch({
    required this.id,
    required this.name,
    required this.beds,
    required this.open,
    required this.close,
    required this.city,
  });
}

class SlotSelection {
  final String bedId;
  final String time;

  SlotSelection({required this.bedId, required this.time});
}
