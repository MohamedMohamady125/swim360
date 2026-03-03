import 'package:flutter/material.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({super.key});

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final List<String> _governorates = ["Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", "Gharbia", "Ismailia", "Luxor", "Matrouh", "Minya", "Monufia", "New Valley", "North Sinai", "Port Said", "Qalyubia", "Qena", "Sharqia", "Sohag", "South Sinai", "Suez"];

  final List<String> _clinicServices = [
    "Manual Therapy",
    "Sports Rehabilitation",
    "Post-Surgical Rehab",
    "Dry Needling",
    "Cupping Therapy",
    "Hydrotherapy",
    "Gait Analysis",
    "Ergonomic Assessment"
  ];

  String? _notificationMsg;
  String _notificationType = 'success';
  bool _isLoading = false;

  String _governorate = 'Cairo';
  String _city = '';
  String _locationName = '';
  String _locationUrl = '';
  String _numberOfBeds = '';
  String _openingHour = '08';
  String _openingMinute = '00';
  String _openingAmpm = 'AM';
  String _closingHour = '05';
  String _closingMinute = '00';
  String _closingAmpm = 'PM';
  List<String> _selectedServices = [];

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

  void _toggleService(String service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
    });
  }

  void _handleSubmit() {
    if (_city.isEmpty || _locationName.isEmpty || _numberOfBeds.isEmpty || _selectedServices.isEmpty) {
      _showNotification("Please fill in all required fields and services", "error");
      return;
    }

    // Time Validation
    final openTotal = (int.parse(_openingHour) % 12 + (_openingAmpm == 'PM' ? 12 : 0)) * 60 + int.parse(_openingMinute);
    final closeTotal = (int.parse(_closingHour) % 12 + (_closingAmpm == 'PM' ? 12 : 0)) * 60 + int.parse(_closingMinute);

    if (closeTotal <= openTotal) {
      _showNotification("Closing time must be after opening time", "error");
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification("Clinic Branch Registered Successfully!");
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
                            child: const Icon(Icons.business, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Register Branch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                              SizedBox(height: 2),
                              Text('CLINIC EXPANSION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
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
                        // 1. Location Details
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
                                  Icon(Icons.location_on, size: 16, color: Color(0xFF2563EB)),
                                  SizedBox(width: 8),
                                  Text('LOCATION DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                ],
                              ),

                              const SizedBox(height: 20),

                              const Text('Governorate', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: DropdownButton<String>(
                                  value: _governorate,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                  items: _governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                                  onChanged: (value) => setState(() => _governorate = value!),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('City', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        TextField(
                                          onChanged: (value) => setState(() => _city = value),
                                          decoration: InputDecoration(
                                            hintText: 'e.g. Maadi',
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
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Treatment Beds', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                        const SizedBox(height: 6),
                                        TextField(
                                          onChanged: (value) => setState(() => _numberOfBeds = value),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'e.g. 5',
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

                              const Text('Location Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                              const SizedBox(height: 6),
                              TextField(
                                onChanged: (value) => setState(() => _locationName = value),
                                decoration: InputDecoration(
                                  hintText: 'e.g. Al Malaz Branch',
                                  hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
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
                                onChanged: (value) => setState(() => _locationUrl = value),
                                decoration: InputDecoration(
                                  hintText: 'Paste maps link...',
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

                        // 2. Operational Hours
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
                                  Text('OPERATIONAL HOURS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                ],
                              ),

                              const SizedBox(height: 20),

                              _buildTimeSelector('Opening Time', 'opening'),
                              const SizedBox(height: 16),
                              _buildTimeSelector('Closing Time', 'closing'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 3. Available Services
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
                                  Icon(Icons.content_paste, size: 16, color: Color(0xFF2563EB)),
                                  SizedBox(width: 8),
                                  Text('AVAILABLE SERVICES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                ],
                              ),

                              const SizedBox(height: 16),

                              ..._clinicServices.map((service) {
                                final isSelected = _selectedServices.contains(service);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InkWell(
                                    onTap: () => _toggleService(service),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
                                        border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))] : [],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(service, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF6B7280))),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB), width: 2),
                                            ),
                                            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Submit Button
                        InkWell(
                          onTap: _isLoading ? null : _handleSubmit,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _isLoading ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                            ),
                            child: Text(
                              _isLoading ? 'REGISTERING...' : 'REGISTER BRANCH',
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

  Widget _buildTimeSelector(String label, String prefix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: prefix == 'opening' ? _openingHour : _closingHour,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                  items: List.generate(12, (i) => (i + 1).toString().padLeft(2, '0')).map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                  onChanged: (value) => setState(() {
                    if (prefix == 'opening') {
                      _openingHour = value!;
                    } else {
                      _closingHour = value!;
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: prefix == 'opening' ? _openingMinute : _closingMinute,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                  items: ["00", "15", "30", "45"].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (value) => setState(() {
                    if (prefix == 'opening') {
                      _openingMinute = value!;
                    } else {
                      _closingMinute = value!;
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: prefix == 'opening' ? _openingAmpm : _closingAmpm,
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                items: ["AM", "PM"].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (value) => setState(() {
                  if (prefix == 'opening') {
                    _openingAmpm = value!;
                  } else {
                    _closingAmpm = value!;
                  }
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
