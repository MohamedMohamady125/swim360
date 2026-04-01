import 'package:flutter/material.dart';
import 'package:swim360/core/services/academy_service.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({Key? key}) : super(key: key);

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationUrlController = TextEditingController();
  final AcademyService _academyService = AcademyService();

  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;

  final List<bool> _selectedDays = List.filled(7, false);
  final List<String> _dayNames = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  final List<PoolEntry> _poolEntries = [PoolEntry()];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _locationUrlController.dispose();
    super.dispose();
  }

  void _addPoolEntry() {
    setState(() {
      _poolEntries.add(PoolEntry());
    });
  }

  void _removePoolEntry(int index) {
    setState(() {
      _poolEntries.removeAt(index);
    });
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isOpening) {
          _openingTime = picked;
        } else {
          _closingTime = picked;
        }
      });
    }
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Create branch data
        final branchData = {
          'location_name': _nameController.text.trim(),
          'city': _cityController.text.trim(),
          'location_url': _locationUrlController.text.trim(),
          'operating_days': _selectedDays
              .asMap()
              .entries
              .where((e) => e.value)
              .map((e) => _dayNames[e.key])
              .toList(),
        };

        if (_openingTime != null) {
          branchData['opening_hour'] = _openingTime!.hour.toString();
          branchData['opening_minute'] = _openingTime!.minute.toString();
          branchData['opening_ampm'] = _openingTime!.period == DayPeriod.am ? 'AM' : 'PM';
        }
        if (_closingTime != null) {
          branchData['closing_hour'] = _closingTime!.hour.toString();
          branchData['closing_minute'] = _closingTime!.minute.toString();
          branchData['closing_ampm'] = _closingTime!.period == DayPeriod.am ? 'AM' : 'PM';
        }

        // Create branch first
        final branch = await _academyService.createBranch(branchData);

        // Then create pools for this branch
        for (final pool in _poolEntries) {
          if (pool.nameController.text.isNotEmpty) {
            await _academyService.createPool({
              'branch_id': branch.id,
              'pool_name': pool.nameController.text.trim(),
              'lanes': int.tryParse(pool.lanesController.text.trim()) ?? 0,
              'max_capacity': int.tryParse(pool.capacityController.text.trim()) ?? 0,
            });
          }
        }

        if (mounted) {
          _showSnackbar('Branch & Pools Created Successfully!');
          await Future.delayed(const Duration(milliseconds: 1500));
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSubmitting = false);
          _showSnackbar('Failed: ${e.toString()}');
        }
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
                        _buildBranchDetailsCard(),
                        const SizedBox(height: 24),
                        _buildOperatingHoursCard(),
                        const SizedBox(height: 24),
                        _buildCapacityCard(),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADD BRANCH',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -1.0,
                  fontStyle: FontStyle.italic,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'NEW ACADEMY NODE CONFIGURATION',
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

  Widget _buildBranchDetailsCard() {
    return _buildFormCard(
      icon: Icons.business_outlined,
      iconColor: const Color(0xFF3B82F6),
      iconBgColor: const Color(0xFFDBeafe),
      title: 'BRANCH DETAILS',
      child: Column(
        children: [
          _buildTextField(
            label: 'BRANCH NAME',
            controller: _nameController,
            placeholder: 'DOWNTOWN AQUATIC HUB',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'OPERATION CITY',
                  controller: _cityController,
                  placeholder: 'RIYADH',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildTextField(
                  label: 'LOCATION (URL)',
                  controller: _locationUrlController,
                  placeholder: 'HTTPS://MAPS.GOOGLE.COM/...',
                  keyboardType: TextInputType.url,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHoursCard() {
    return _buildFormCard(
      icon: Icons.access_time,
      iconColor: const Color(0xFF9333EA),
      iconBgColor: const Color(0xFFF3E8FF),
      title: 'OPERATING HOURS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'WEEKLY CYCLE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF94A3B8),
                letterSpacing: 2.5,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_dayNames.length, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDays[index] = !_selectedDays[index];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedDays[index]
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _selectedDays[index]
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ]
                        : [],
                  ),
                  transform: _selectedDays[index]
                      ? Matrix4.translationValues(0, -2, 0)
                      : Matrix4.identity(),
                  child: Text(
                    _dayNames[index].toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: _selectedDays[index]
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildTimeField(
                  label: 'OPENING',
                  time: _openingTime,
                  onTap: () => _selectTime(context, true),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildTimeField(
                  label: 'CLOSING',
                  time: _closingTime,
                  onTap: () => _selectTime(context, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityCard() {
    return _buildFormCard(
      icon: Icons.waves,
      iconColor: const Color(0xFF10B981),
      iconBgColor: const Color(0xFFD1FAE5),
      title: 'CAPACITY',
      trailing: TextButton(
        onPressed: _addPoolEntry,
        child: Text(
          '+ ADD ASSET',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF2563EB),
            letterSpacing: 2.5,
          ),
        ),
      ),
      child: Column(
        children: List.generate(_poolEntries.length, (index) {
          return Padding(
            padding: EdgeInsets.only(top: index > 0 ? 24 : 0),
            child: _buildPoolEntry(index),
          );
        }),
      ),
    );
  }

  Widget _buildPoolEntry(int index) {
    final entry = _poolEntries[index];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          style: BorderStyle.solid,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'POOLS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              _buildInputGroup(
                controller: entry.nameController,
                placeholder: index == 0
                    ? 'MAIN COMPETITION POOL'
                    : 'SECONDARY TRAINING POOL',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'LANES',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF94A3B8),
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        _buildInputGroup(
                          controller: entry.lanesController,
                          placeholder: index == 0 ? '8' : '4',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            index == 0 ? 'MAXIMUM CAPACITY' : 'VOLUME CAP.',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF94A3B8),
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                        _buildInputGroup(
                          controller: entry.capacityController,
                          placeholder: index == 0 ? '40' : '20',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (index > 0)
            Positioned(
              top: -12,
              right: -12,
              child: InkWell(
                onTap: () => _removePoolEntry(index),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFFDC2626),
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    Widget? trailing,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
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
              if (trailing != null) trailing,
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
        _buildInputGroup(
          controller: controller,
          placeholder: placeholder,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildInputGroup({
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
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
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null ? time.format(context) : '--:--',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: time != null
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
                Icon(
                  Icons.access_time,
                  color: const Color(0xFF94A3B8),
                  size: 20,
                ),
              ],
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
          border: const Border(
            top: BorderSide(color: Color(0xFFF1F5F9)),
          ),
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
            shadowColor: const Color(0xFF10B981).withOpacity(0.2),
          ),
          child: _isSubmitting
              ? Text(
                  'PROCESSING REGISTRY...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CREATE BRANCH',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.check, size: 24),
                  ],
                ),
        ),
      ),
    );
  }
}

class PoolEntry {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lanesController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();

  void dispose() {
    nameController.dispose();
    lanesController.dispose();
    capacityController.dispose();
  }
}
