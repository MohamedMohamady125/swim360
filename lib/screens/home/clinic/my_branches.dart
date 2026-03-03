import 'package:flutter/material.dart';
import 'package:swim360/core/services/clinic_service.dart';
import 'package:swim360/core/models/clinic_models.dart';

class MyBranchesScreen extends StatefulWidget {
  const MyBranchesScreen({super.key});

  @override
  State<MyBranchesScreen> createState() => _MyBranchesScreenState();
}

class _MyBranchesScreenState extends State<MyBranchesScreen> {
  final ClinicApiService _clinicService = ClinicApiService();

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

  List<ClinicBranch> _branches = [];

  String _view = 'list'; // 'list' or 'edit'
  Map<String, dynamic>? _editingData;
  String? _editingId;
  String? _notificationMsg;
  String _notificationType = 'success';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final branches = await _clinicService.getMyBranches();

      if (mounted) {
        setState(() {
          _branches = branches;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load branches: $e';
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

  void _handleEditClick(ClinicBranch branch) {
    setState(() {
      _editingId = branch.id;
      _editingData = {
        'location_name': branch.locationName,
        'governorate': branch.governorate ?? 'Cairo',
        'city': branch.city ?? '',
        'location_url': branch.locationUrl ?? '',
        'number_of_beds': branch.numberOfBeds,
        'opening_hour': branch.openingHour ?? '08',
        'opening_minute': branch.openingMinute ?? '00',
        'opening_ampm': branch.openingAmpm ?? 'AM',
        'closing_hour': branch.closingHour ?? '05',
        'closing_minute': branch.closingMinute ?? '00',
        'closing_ampm': branch.closingAmpm ?? 'PM',
        'services_offered': List<String>.from(branch.servicesOffered ?? []),
      };
      _view = 'edit';
    });
  }

  void _toggleService(String serviceId) {
    final id = serviceId.toLowerCase().replaceAll(' ', '-');
    setState(() {
      final services = _editingData!['services_offered'] as List<String>;
      if (services.contains(id)) {
        services.remove(id);
      } else {
        services.add(id);
      }
    });
  }

  Future<void> _handleSave() async {
    if (_editingData == null || _editingId == null) return;

    // Time Validation
    final openHour = int.parse(_editingData!['opening_hour'] as String);
    final openMin = int.parse(_editingData!['opening_minute'] as String);
    final openAmpm = _editingData!['opening_ampm'] as String;
    final closeHour = int.parse(_editingData!['closing_hour'] as String);
    final closeMin = int.parse(_editingData!['closing_minute'] as String);
    final closeAmpm = _editingData!['closing_ampm'] as String;

    final openTotal = (openHour % 12 + (openAmpm == 'PM' ? 12 : 0)) * 60 + openMin;
    final closeTotal = (closeHour % 12 + (closeAmpm == 'PM' ? 12 : 0)) * 60 + closeMin;

    if (closeTotal <= openTotal) {
      _showNotification("Closing time must be after opening time", "error");
      return;
    }

    final services = _editingData!['services_offered'] as List<String>;
    if (services.isEmpty) {
      _showNotification("Please select at least one service", "error");
      return;
    }

    try {
      setState(() => _isLoading = true);

      await _clinicService.updateBranch(_editingId!, _editingData!);
      await _loadBranches();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _view = 'list';
        });
        _showNotification("Branch updated successfully!");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification("Failed to update branch: $e", "error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading && _branches.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading branches...'),
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
                  onPressed: _loadBranches,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: _view == 'list' ? _buildListView() : _buildEditView(),
          ),
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

  Widget _buildListView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Branches', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          const Text('Manage and edit your clinic locations', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 32),

          ..._branches.map((branch) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(branch.locationName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF2563EB)),
                            const SizedBox(width: 4),
                            Text('${branch.city}, ${branch.governorate}'.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 12, color: Color(0xFF9CA3AF)),
                                const SizedBox(width: 4),
                                Text('${branch.openingHour}:${branch.openingMinute} ${branch.openingAmpm} - ${branch.closingHour}:${branch.closingMinute} ${branch.closingAmpm}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                const Icon(Icons.layers, size: 12, color: Color(0xFF9CA3AF)),
                                const SizedBox(width: 4),
                                Text('${branch.numberOfBeds} Beds', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _handleEditClick(branch),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.edit_outlined, color: Color(0xFF2563EB), size: 20),
                    ),
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
                  const Text('Edit Branch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                ],
              ),
              InkWell(
                onTap: _isLoading ? null : _handleSave,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Text(_isLoading ? 'SAVING...' : 'SAVE', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Location Information
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
                          Icon(Icons.navigation, size: 16, color: Color(0xFF2563EB)),
                          SizedBox(width: 8),
                          Text('LOCATION INFORMATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
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
                          value: _editingData?['governorate'] as String? ?? 'Cairo',
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                          items: _governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (value) => setState(() => _editingData!['governorate'] = value!),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text('City', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: _editingData?['city'] as String?),
                        onChanged: (value) => _editingData!['city'] = value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),

                      const SizedBox(height: 16),

                      const Text('Location Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: _editingData?['location_name'] as String?),
                        onChanged: (value) => _editingData!['location_name'] = value,
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
                        controller: TextEditingController(text: _editingData?['location_url'] as String?),
                        onChanged: (value) => _editingData!['location_url'] = value,
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

                // 2. Capacity & Hours
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
                          Text('OPERATIONAL SETTINGS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text('Treatment Beds', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: (_editingData?['number_of_beds'] as int?)?.toString()),
                        onChanged: (value) => _editingData!['number_of_beds'] = int.tryParse(value) ?? 0,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),

                      const SizedBox(height: 24),

                      _buildTimeSelector('Opening Time', 'opening'),
                      const SizedBox(height: 16),
                      _buildTimeSelector('Closing Time', 'closing'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Services Offered
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
                          Text('AVAILABLE SERVICES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      ..._clinicServices.map((service) {
                        final serviceId = service.toLowerCase().replaceAll(' ', '-');
                        final services = _editingData!['services_offered'] as List<String>;
                        final isSelected = services.contains(serviceId);

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
              ],
            ),
          ),
        ),
      ],
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
                  value: prefix == 'opening' ? (_editingData?['opening_hour'] as String?) : (_editingData?['closing_hour'] as String?),
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                  items: List.generate(12, (i) => (i + 1).toString().padLeft(2, '0')).map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                  onChanged: (value) => setState(() {
                    if (prefix == 'opening') {
                      _editingData!['opening_hour'] = value!;
                    } else {
                      _editingData!['closing_hour'] = value!;
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
                  value: prefix == 'opening' ? (_editingData?['opening_minute'] as String?) : (_editingData?['closing_minute'] as String?),
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                  items: ["00", "15", "30", "45"].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (value) => setState(() {
                    if (prefix == 'opening') {
                      _editingData!['opening_minute'] = value!;
                    } else {
                      _editingData!['closing_minute'] = value!;
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
                value: prefix == 'opening' ? (_editingData?['opening_ampm'] as String?) : (_editingData?['closing_ampm'] as String?),
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                items: ["AM", "PM"].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (value) => setState(() {
                  if (prefix == 'opening') {
                    _editingData!['opening_ampm'] = value!;
                  } else {
                    _editingData!['closing_ampm'] = value!;
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
