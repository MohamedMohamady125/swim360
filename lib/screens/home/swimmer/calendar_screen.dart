import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime(2025, 9); // September 2025
  final DateTime _startDate = DateTime(2025, 9); // Cannot go before this

  final Map<String, List<Activity>> _activityData = {
    '2025-9-1': [Activity(time: '05:00 PM', title: 'Beginner Level 1', type: 'academy', provider: 'Blue Wave Academy')],
    '2025-9-3': [Activity(time: '04:00 PM', title: 'Physiotherapy Assessment', type: 'clinic', provider: 'AquaHealth Clinic')],
    '2025-9-6': [Activity(time: '11:00 AM', title: 'Dryland Technique Analysis', type: 'online', provider: 'Coach Mike (Zoom)')],
    '2025-9-8': [
      Activity(time: '05:00 PM', title: 'Beginner Level 1', type: 'academy', provider: 'Blue Wave Academy'),
      Activity(time: '02:00 PM', title: 'Goggles Delivered', type: 'order', provider: 'Swim Pro Store'),
    ],
    '2025-9-12': [Activity(time: '06:00 PM', title: 'Nutrition Webinar', type: 'online', provider: 'Dr. Sarah Wilson')],
    '2025-9-15': [Activity(time: '09:00 AM', title: 'Regional Swim Meet', type: 'event', provider: 'Swim Federation')],
    '2025-9-24': [Activity(time: '04:00 PM', title: 'Physiotherapy Recovery', type: 'clinic', provider: 'AquaHealth Clinic')],
    '2025-10-5': [Activity(time: '05:30 PM', title: 'Intermediate Squad', type: 'academy', provider: 'Elite Academy')],
    '2025-10-10': [Activity(time: '04:00 PM', title: 'Virtual Stroke Review', type: 'online', provider: 'Coach Elena')],
    '2025-10-12': [Activity(time: '10:00 AM', title: 'Stroke Clinic', type: 'event', provider: 'Coach Michael')],
    '2025-10-20': [Activity(time: '03:00 PM', title: 'Order: Fins & Cap', type: 'order', provider: 'Marketplace')],
  };

  List<Activity> _getActivitiesForDate(DateTime date) {
    final key = '${date.year}-${date.month}-${date.day}';
    return _activityData[key] ?? [];
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'academy':
        return const Color(0xFF2563EB);
      case 'clinic':
        return const Color(0xFF10B981);
      case 'event':
        return const Color(0xFFEF4444);
      case 'order':
        return const Color(0xFFF97316);
      case 'online':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF2563EB);
    }
  }

  void _previousMonth() {
    final newDate = DateTime(_currentDate.year, _currentDate.month - 1);
    if (newDate.isBefore(_startDate)) return;
    setState(() {
      _currentDate = newDate;
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  void _showDayAgenda(DateTime date) {
    final activities = _getActivitiesForDate(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAgendaModal(date, activities),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDayOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    final canGoPrevious = !DateTime(_currentDate.year, _currentDate.month - 1).isBefore(_startDate);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF1E293B)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Calendar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      // Month Navigator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${_getMonthName(_currentDate.month).substring(0, 3)} ${_currentDate.year}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: 1.5,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 16),
                              padding: const EdgeInsets.only(left: 16),
                              decoration: const BoxDecoration(
                                border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: canGoPrevious ? _previousMonth : null,
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 16,
                                      color: canGoPrevious ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: _nextMonth,
                                    child: const Icon(Icons.chevron_right, size: 16, color: Color(0xFF2563EB)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Weekday Headers
                    Row(
                      children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              day.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFCBD5E1),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Calendar Days
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.91,
                      ),
                      itemCount: 42,
                      itemBuilder: (context, index) {
                        final dayNumber = index - firstWeekday + 1;

                        if (dayNumber < 1 || dayNumber > daysInMonth) {
                          return const SizedBox();
                        }

                        final date = DateTime(_currentDate.year, _currentDate.month, dayNumber);
                        final activities = _getActivitiesForDate(date);
                        final uniqueTypes = activities.map((a) => a.type).toSet().toList();

                        return InkWell(
                          onTap: () => _showDayAgenda(date),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$dayNumber',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                if (uniqueTypes.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 2,
                                    children: uniqueTypes.map((type) {
                                      return Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: _getActivityColor(type),
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    // Color Legend
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildLegendItem('Academy', const Color(0xFF2563EB)),
                        _buildLegendItem('Clinic', const Color(0xFF10B981)),
                        _buildLegendItem('Events', const Color(0xFFEF4444)),
                        _buildLegendItem('Online', const Color(0xFF8B5CF6)),
                        _buildLegendItem('Orders', const Color(0xFFF97316)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Tap any date with markers to view your daily agenda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFCBD5E1),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Color(0xFF94A3B8),
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaModal(DateTime date, List<Activity> activities) {
    final dayName = _getDayName(date.weekday);
    final monthName = _getMonthName(date.month).substring(0, 3);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$dayName, ${date.day} $monthName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your Schedule',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  activities.length == 1 ? '1 Activity' : '${activities.length} Activities',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calendar_today, color: Color(0xFFE2E8F0), size: 32),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Free Day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'No sessions or deliveries scheduled.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            )
          else
            ...activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLast = index == activities.length - 1;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _getActivityColor(activity.type),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: _getActivityColor(activity.type).withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 48,
                            color: const Color(0xFFF1F5F9),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.time.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 2.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activity.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activity.provider.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Text(
                'Close Agenda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }
}

class Activity {
  final String time;
  final String title;
  final String type;
  final String provider;

  Activity({
    required this.time,
    required this.title,
    required this.type,
    required this.provider,
  });
}
