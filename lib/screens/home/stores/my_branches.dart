import 'package:flutter/material.dart';
import 'package:swim360/core/services/store_service.dart';
import 'package:swim360/core/models/store_models.dart';

class MyBranchesScreen extends StatefulWidget {
  const MyBranchesScreen({super.key});

  @override
  State<MyBranchesScreen> createState() => _MyBranchesScreenState();
}

class _MyBranchesScreenState extends State<MyBranchesScreen> {
  final StoreApiService _storeService = StoreApiService();

  String _view = 'list'; // 'list' or 'edit'
  Map<String, dynamic>? _editingData;
  String? _editingId;

  List<StoreBranch> _branches = [];
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, String>> _deliveryOptions = [
    {'id': 'pickup-only', 'label': 'Pickup Only'},
    {'id': 'governorate-delivery', 'label': 'Governorate Delivery'},
    {'id': 'national-delivery', 'label': 'National Delivery'},
    {'id': 'international-delivery', 'label': 'International Delivery'},
  ];

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

      final branches = await _storeService.getMyBranches();

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

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: const Color(0xFF1F2937)),
    );
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
      body: SafeArea(
        child: _view == 'list' ? _buildList() : _buildEdit(),
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('My Branches', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
        const SizedBox(height: 4),
        const Text('Manage and monitor your retail outlets', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
        const SizedBox(height: 32),
        ..._branches.map((branch) {
          return Padding(
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
                        Text(branch.locationName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 12),
                            const SizedBox(width: 4),
                            Text('${branch.city ?? 'N/A'}, ${branch.governorate ?? 'N/A'}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (branch.openingHour != null) Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFF9CA3AF), size: 12),
                            const SizedBox(width: 4),
                            Text('${branch.openingHour}:${branch.openingMinute} ${branch.openingAmpm} - ${branch.closingHour}:${branch.closingMinute} ${branch.closingAmpm}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 1.0)),
                          ],
                        ),
                        if (branch.openingHour != null) const SizedBox(height: 6),
                        if (branch.branchPhone != null) Row(
                          children: [
                            const Icon(Icons.phone, color: Color(0xFF9CA3AF), size: 12),
                            const SizedBox(width: 4),
                            Text(branch.branchPhone!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 1.0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _editingId = branch.id;
                        _editingData = {
                          'location_name': branch.locationName,
                          'governorate': branch.governorate ?? '',
                          'city': branch.city ?? '',
                          'location_url': branch.locationUrl ?? '',
                          'branch_phone': branch.branchPhone ?? '',
                          'opening_hour': branch.openingHour ?? '09',
                          'opening_minute': branch.openingMinute ?? '00',
                          'opening_ampm': branch.openingAmpm ?? 'AM',
                          'closing_hour': branch.closingHour ?? '05',
                          'closing_minute': branch.closingMinute ?? '00',
                          'closing_ampm': branch.closingAmpm ?? 'PM',
                          'delivery_options': List<String>.from(branch.deliveryOptions ?? []),
                        };
                        _view = 'edit';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.edit, color: Color(0xFF2563EB), size: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEdit() {
    return Column(
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
                  InkWell(
                    onTap: () => setState(() => _view = 'list'),
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.arrow_back, size: 24)),
                  ),
                  const SizedBox(width: 16),
                  const Text('Edit Branch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
              InkWell(
                onTap: () async {
                  if (_editingData == null || _editingId == null) return;

                  try {
                    setState(() => _isLoading = true);

                    await _storeService.updateBranch(_editingId!, _editingData!);
                    await _loadBranches();

                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _view = 'list';
                      });
                      _showNotification('Branch updated successfully!');
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() => _isLoading = false);
                      _showNotification('Failed to update branch: $e');
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]),
                  child: Text(_isLoading ? 'SAVING...' : 'SAVE', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                ),
              ),
            ],
          ),
        ),

        // Form
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Location Details
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.navigation, color: Color(0xFF2563EB), size: 16), SizedBox(width: 8), Text('LOCATION DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0))]),
                    const SizedBox(height: 16),
                    const Text('Store Location Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: _editingData?['location_name'] as String?),
                      onChanged: (value) => _editingData!['location_name'] = value,
                      decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF9FAFB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16)),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Operations
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.access_time, color: Color(0xFF2563EB), size: 16), SizedBox(width: 8), Text('OPERATIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0))]),
                    const SizedBox(height: 16),
                    const Text('Branch Phone Number', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: _editingData?['branch_phone'] as String?),
                      onChanged: (value) => _editingData!['branch_phone'] = value,
                      decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF9FAFB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16)),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Fulfillment Options
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.local_shipping, color: Color(0xFF2563EB), size: 16), SizedBox(width: 8), Text('FULFILLMENT OPTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0))]),
                    const SizedBox(height: 16),
                    ..._deliveryOptions.map((option) {
                      final deliveryOpts = _editingData?['delivery_options'] as List<String>? ?? [];
                      final isSelected = deliveryOpts.contains(option['id']);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              final opts = _editingData!['delivery_options'] as List<String>;
                              if (isSelected) {
                                opts.remove(option['id']);
                              } else {
                                opts.add(option['id']!);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(option['label']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF6B7280))),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB), width: 2),
                                  ),
                                  child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
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
      ],
    );
  }
}
