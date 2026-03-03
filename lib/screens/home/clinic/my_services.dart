import 'package:flutter/material.dart';
import 'package:swim360/core/services/clinic_service.dart';
import 'package:swim360/core/models/clinic_models.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  final ClinicApiService _clinicService = ClinicApiService();
  final List<String> _categories = ["Rehabilitation", "Assessment", "Recovery", "Manual Therapy", "Other"];

  List<ClinicService> _services = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _view = 'list'; // 'list', 'add', 'edit'
  Map<String, dynamic>? _editingData; // Form data being edited
  String? _editingId; // ID of service being edited (null for new)
  String _searchTerm = '';
  String? _notificationMsg;
  String _notificationType = 'success';

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

  List<ClinicService> get _filteredServices {
    return _services.where((s) {
      return s.title.toLowerCase().contains(_searchTerm.toLowerCase()) ||
             (s.category?.toLowerCase() ?? '').contains(_searchTerm.toLowerCase());
    }).toList()..sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final services = await _clinicService.getMyServices();

      if (mounted) {
        setState(() {
          _services = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load services: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _handleAddClick() {
    setState(() {
      _editingData = {
        'title': '',
        'category': 'Rehabilitation',
        'price': 0.0,
        'duration': '60 min',
        'description': '',
        'video_url': '',
        'photo_url': 'https://placehold.co/100x100/2563eb/ffffff?text=+',
      };
      _editingId = null;
      _view = 'add';
    });
  }

  void _handleEditClick(ClinicService service) {
    setState(() {
      _editingData = {
        'title': service.title,
        'category': service.category ?? 'Rehabilitation',
        'price': service.price,
        'duration': service.duration ?? '60 min',
        'description': service.description ?? '',
        'video_url': service.videoUrl ?? '',
        'photo_url': service.photoUrl ?? 'https://placehold.co/100x100/2563eb/ffffff?text=+',
      };
      _editingId = service.id;
      _view = 'edit';
    });
  }

  Future<void> _handleSave() async {
    if (_editingData == null) return;

    final title = _editingData!['title'] as String? ?? '';
    final description = _editingData!['description'] as String? ?? '';
    final price = _editingData!['price'] as double? ?? 0.0;

    if (title.isEmpty || price == 0 || description.isEmpty) {
      _showNotification("Please fill in all required fields", "error");
      return;
    }

    try {
      setState(() => _isLoading = true);

      if (_editingId == null) {
        // Create new service
        await _clinicService.createService(_editingData!);
        _showNotification("Service created successfully!");
      } else {
        // Update existing service
        await _clinicService.updateService(_editingId!, _editingData!);
        _showNotification("Service updated successfully!");
      }

      // Reload services from backend
      await _loadServices();

      if (mounted) {
        setState(() {
          _view = 'list';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification("Failed to save service: $e", "error");
      }
    }
  }

  Future<void> _handleDelete(String serviceId) async {
    try {
      setState(() => _isLoading = true);
      await _clinicService.deleteService(serviceId);
      await _loadServices();
      _showNotification("Service deleted successfully!");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showNotification("Failed to delete service: $e", "error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: _view == 'list' ? _buildListView() : _buildFormView(),
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
    // Show loading indicator
    if (_isLoading && _services.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading services...', style: TextStyle(color: Color(0xFF9CA3AF))),
          ],
        ),
      );
    }

    // Show error message
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF9CA3AF))),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadServices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Services', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          const Text('Manage treatments and programs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 32),

          // Add Service Banner
          InkWell(
            onTap: _handleAddClick,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text('ADD NEW SERVICE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.6), size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchTerm = value),
              decoration: const InputDecoration(
                hintText: 'Search treatments...',
                hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 24),

          // Empty State
          if (_filteredServices.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.medical_services_outlined, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      _searchTerm.isEmpty ? 'No services yet' : 'No services found',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _searchTerm.isEmpty
                        ? 'Tap "ADD NEW SERVICE" to create your first service'
                        : 'Try a different search term',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
            ),

          // Services List
          ..._filteredServices.map((service) => Padding(
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
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(service.photoUrl ?? 'https://placehold.co/100x100/2563eb/ffffff?text=+', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, height: 1.2), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text((service.category ?? 'OTHER').toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('\$${service.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                            const SizedBox(width: 12),
                            const Text('|', style: TextStyle(color: Color(0xFFE5E7EB))),
                            const SizedBox(width: 12),
                            Text((service.duration ?? 'N/A').toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _handleEditClick(service),
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

          if (_filteredServices.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(
                child: Text('No services found...', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF9CA3AF))),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormView() {
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
                  Text(_view == 'add' ? 'New Service' : 'Edit Service', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                ],
              ),
              InkWell(
                onTap: _handleSave,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Text('SAVE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
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
                // 1. Basic Info
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
                          Text('SERVICE DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Service Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: _editingData?['title']),
                        onChanged: (value) => setState(() => _editingData!['title'] = value),
                        decoration: InputDecoration(
                          hintText: 'e.g. Spine Assessment',
                          hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      const Text('Category', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButton<String>(
                          value: _editingData?['category'] ?? 'Rehabilitation',
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (value) => setState(() => _editingData!['category'] = value!),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Media
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
                          Icon(Icons.image_outlined, size: 16, color: Color(0xFF2563EB)),
                          SizedBox(width: 8),
                          Text('MEDIA GALLERY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.add, color: Color(0xFF2563EB), size: 24),
                                  SizedBox(height: 4),
                                  Text('ADD PHOTO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.videocam_outlined, color: Color(0xFF9CA3AF), size: 24),
                                  SizedBox(height: 4),
                                  Text('INTRO VIDEO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_editingId != null && _editingId!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('Intro Video URL (Optional)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: TextEditingController(text: _editingData?['video_url']),
                          onChanged: (value) => setState(() => _editingData!['video_url'] = value),
                          decoration: InputDecoration(
                            hintText: 'https://youtube.com/...',
                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Pricing & Logistics
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
                          Icon(Icons.attach_money, size: 16, color: Color(0xFF2563EB)),
                          SizedBox(width: 8),
                          Text('PRICING & TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
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
                                TextField(
                                  controller: TextEditingController(text: _editingData?['price']?.toString() ?? '0'),
                                  onChanged: (value) => setState(() => _editingData!['price'] = double.tryParse(value) ?? 0.0),
                                  keyboardType: TextInputType.number,
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Duration', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: TextEditingController(text: _editingData?['duration']),
                                  onChanged: (value) => setState(() => _editingData!['duration'] = value),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 60 min',
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
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Description
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
                          Icon(Icons.work_outline, size: 16, color: Color(0xFF2563EB)),
                          SizedBox(width: 8),
                          Text('DESCRIPTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(text: _editingData?['description']),
                        onChanged: (value) => setState(() => _editingData!['description'] = value),
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Describe the treatment benefits and process...',
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
          ),
        ),
      ],
    );
  }
}

