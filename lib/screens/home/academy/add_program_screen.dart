import 'package:flutter/material.dart';

class AddProgramScreen extends StatefulWidget {
  const AddProgramScreen({Key? key}) : super(key: key);

  @override
  State<AddProgramScreen> createState() => _AddProgramScreenState();
}

class _AddProgramScreenState extends State<AddProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  final _durationController = TextEditingController();
  final _sessionsController = TextEditingController();

  final Map<String, DaySchedule> _daySchedules = {
    'Sat': DaySchedule('Saturday'),
    'Sun': DaySchedule('Sunday'),
    'Mon': DaySchedule('Monday'),
    'Tue': DaySchedule('Tuesday'),
    'Wed': DaySchedule('Wednesday'),
    'Thu': DaySchedule('Thursday'),
    'Fri': DaySchedule('Friday'),
  };

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _durationController.dispose();
    _sessionsController.dispose();
    super.dispose();
  }

  void _toggleDay(String dayKey) {
    setState(() {
      final schedule = _daySchedules[dayKey]!;
      schedule.isActive = !schedule.isActive;
      if (schedule.isActive && schedule.timeSlots.isEmpty) {
        schedule.timeSlots.add(TimeSlot());
      } else if (!schedule.isActive) {
        schedule.timeSlots.clear();
      }
    });
  }

  void _addTimeSlot(String dayKey) {
    setState(() {
      _daySchedules[dayKey]!.timeSlots.add(TimeSlot());
    });
  }

  void _removeTimeSlot(String dayKey, int index) {
    setState(() {
      _daySchedules[dayKey]!.timeSlots.removeAt(index);
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _showSnackbar('Program Registered Successfully!');
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildDetailsCard(),
                        const SizedBox(height: 24),
                        _buildPricingCard(),
                        const SizedBox(height: 24),
                        _buildScheduleCard(),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 24),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEW PROGRAM',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  fontStyle: FontStyle.italic,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'TRAINING LEVEL DEFINITION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 3.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return _buildFormCard(
      icon: Icons.assignment_outlined,
      iconColor: const Color(0xFF3B82F6),
      iconBgColor: const Color(0xFFDBeafe),
      title: 'PROGRAM DETAILS',
      child: Column(
        children: [
          _buildTextField(
            label: 'PROGRAM TITLE (LEVEL)',
            controller: _titleController,
            placeholder: 'E.G., INTERMEDIATE STROKE SQUAD',
          ),
          const SizedBox(height: 24),
          _buildTextField(
            label: 'DESCRIPTION',
            controller: _descriptionController,
            placeholder: 'Outline the technical focus and goals...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return _buildFormCard(
      icon: Icons.attach_money,
      iconColor: const Color(0xFF10B981),
      iconBgColor: const Color(0xFFD1FAE5),
      title: 'PRICE & CAPACITY',
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'SUBSCRIPTION',
              controller: _priceController,
              placeholder: '120.00',
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildTextField(
              label: 'MAXIMUM CAPACITY',
              controller: _capacityController,
              placeholder: '20',
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return _buildFormCard(
      icon: Icons.access_time,
      iconColor: const Color(0xFF9333EA),
      iconBgColor: const Color(0xFFF3E8FF),
      title: 'WEEKLY SCHEDULE',
      child: Column(
        children: [
          ..._daySchedules.entries.map((entry) => _buildDayRow(entry.key, entry.value)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'CYCLE LENGTH',
                    controller: _durationController,
                    placeholder: 'E.G., 3 MONTHS',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    label: 'TOTAL UNIT SESSIONS',
                    controller: _sessionsController,
                    placeholder: '24',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(String dayKey, DaySchedule schedule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: schedule.isActive ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: schedule.isActive ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
          ),
          boxShadow: schedule.isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _toggleDay(dayKey),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: schedule.isActive
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: schedule.isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF2563EB).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            dayKey.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: schedule.isActive ? Colors.white : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        schedule.fullName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF475569),
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (schedule.isActive)
                  TextButton(
                    onPressed: () => _addTimeSlot(dayKey),
                    child: Text(
                      '+ ADD SLOT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF2563EB),
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
              ],
            ),
            if (schedule.isActive && schedule.timeSlots.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...schedule.timeSlots.asMap().entries.map((entry) {
                final index = entry.key;
                final slot = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTimeSlot(dayKey, index, slot),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String dayKey, int index, TimeSlot slot) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'FROM',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFCBD5E1),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: slot.startTime ?? const TimeOfDay(hour: 16, minute: 0),
                            );
                            if (time != null) {
                              setState(() => slot.startTime = time);
                            }
                          },
                          child: Text(
                            slot.startTime?.format(context) ?? '16:00',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: const Color(0xFFF1F5F9),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'TO',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFCBD5E1),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: slot.endTime ?? const TimeOfDay(hour: 17, minute: 0),
                            );
                            if (time != null) {
                              setState(() => slot.endTime = time);
                            }
                          },
                          child: Text(
                            slot.endTime?.format(context) ?? '17:00',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () => _removeTimeSlot(dayKey, index),
          child: Icon(
            Icons.close,
            color: const Color(0xFFCBD5E1),
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF94A3B8),
              letterSpacing: 2.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontWeight: FontWeight.w700,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          child: _isSubmitting
              ? Text('SYNCHRONIZING REGISTRY...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2.0))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('DEPLOY PROGRAM', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                    const SizedBox(width: 12),
                    const Icon(Icons.check, size: 24),
                  ],
                ),
        ),
      ),
    );
  }
}

class DaySchedule {
  final String fullName;
  bool isActive;
  List<TimeSlot> timeSlots;

  DaySchedule(this.fullName, {this.isActive = false, List<TimeSlot>? timeSlots})
      : timeSlots = timeSlots ?? [];
}

class TimeSlot {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  TimeSlot({this.startTime, this.endTime});
}
