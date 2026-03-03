import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 0;
  final days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  final Map<String, List<Map<String, String>>> schedules = {
    'Sat': [],
    'Sun': [],
    'Mon': [
      {'time': '16:00 - 17:00', 'program': 'Intermediate Squad', 'pool': 'Main Pool'},
      {'time': '17:30 - 18:30', 'program': 'Elite Mastery', 'pool': 'Competition Pool'},
    ],
    'Tue': [],
    'Wed': [
      {'time': '16:00 - 17:00', 'program': 'Intermediate Squad', 'pool': 'Main Pool'},
    ],
    'Thu': [],
    'Fri': [],
  };

  @override
  Widget build(BuildContext context) {
    final selectedDay = days[_selectedDayIndex];
    final sessions = schedules[selectedDay] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFF1F5F9)), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.arrow_back_ios_new, size: 24)),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SCHEDULE', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.0, fontStyle: FontStyle.italic, height: 1.0)),
                          const SizedBox(height: 8),
                          Text('WEEKLY SESSIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 3.0, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _selectedDayIndex;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => _selectedDayIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                                border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))] : [],
                              ),
                              child: Center(
                                child: Text(
                                  days[index].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                      child: Text(
                        'NO SESSIONS SCHEDULED',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFFD1D5DB), letterSpacing: 2.5, fontStyle: FontStyle.italic),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                              boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 4))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                                  child: Text(session['time']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFF2563EB), letterSpacing: 1.0)),
                                ),
                                const SizedBox(height: 16),
                                Text(session['program']!.toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 16, color: const Color(0xFF9CA3AF)),
                                    const SizedBox(width: 8),
                                    Text(session['pool']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF9CA3AF))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
