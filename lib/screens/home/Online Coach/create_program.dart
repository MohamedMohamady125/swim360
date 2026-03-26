import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';

class CreateProgramScreen extends StatefulWidget {
  const CreateProgramScreen({super.key});

  @override
  State<CreateProgramScreen> createState() => _CreateProgramScreenState();
}

class _CreateProgramScreenState extends State<CreateProgramScreen> {
  final StorageService _storageService = StorageService();
  String _deliveryMethod = 'live';
  String _durationUnit = 'Weeks';
  String? _coverFileName;
  bool _isPublishing = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _maxClientsController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _maxClientsController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  String _mapDeliveryToCategory(String delivery) {
    switch (delivery) {
      case 'live':
        return 'adults';
      case 'self-paced':
        return 'beginner';
      case 'hybrid':
        return 'intermediate';
      default:
        return 'beginner';
    }
  }

  Future<void> _handleSubmit() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PLEASE ENTER A PROGRAM TITLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isPublishing = true);

    try {
      final token = await _storageService.getAccessToken();
      final durationWeeks = int.tryParse(_durationController.text) ?? 12;
      final price = double.tryParse(_priceController.text) ?? 0.0;

      final body = jsonEncode({
        'program_name': _titleController.text,
        'category': _mapDeliveryToCategory(_deliveryMethod),
        'description': _descriptionController.text,
        'duration_weeks': _durationUnit == 'Weeks' ? durationWeeks : (durationWeeks * 4),
        'sessions_per_week': 3,
        'session_duration_minutes': 60,
        'price': price,
        'currency': 'EGP',
        'cover_photo_url': _coverFileName ?? '',
      });

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/programs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (mounted) {
        setState(() => _isPublishing = false);
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PROGRAM PUBLISHED!', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
              backgroundColor: Color(0xFF10B981),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('FAILED TO PUBLISH: ${response.statusCode}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPublishing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR: ${e.toString()}'.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
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
                        child: const Icon(Icons.edit, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BUILD PROGRAM', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                          SizedBox(height: 2),
                          Text('CURRICULUM & PRICING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 20),
                    ),
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
                    // 1. General Info
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
                              Icon(Icons.description, size: 16, color: Color(0xFF2563EB)),
                              SizedBox(width: 8),
                              Text('GENERAL INFO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text('Program Title', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'e.g. Elite Performance Coaching',
                              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          const Text('Delivery Method', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButton<String>(
                              value: _deliveryMethod,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                              items: const [
                                DropdownMenuItem(value: 'live', child: Text('Live / Scheduled Sessions')),
                                DropdownMenuItem(value: 'self-paced', child: Text('Self-Paced (Video Only)')),
                                DropdownMenuItem(value: 'hybrid', child: Text('Hybrid (Mixed)')),
                              ],
                              onChanged: (value) => setState(() => _deliveryMethod = value!),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 2. Media & Description
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
                              Icon(Icons.image, size: 16, color: Color(0xFF2563EB)),
                              SizedBox(width: 8),
                              Text('MEDIA & DESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text('Cover Photo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              // File picker would go here
                              setState(() => _coverFileName = 'program_cover.jpg');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.upload, color: _coverFileName != null ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF), size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    _coverFileName ?? 'UPLOAD IMAGE',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _coverFileName != null ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF), letterSpacing: 3.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Intro Video URL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _videoUrlController,
                            decoration: InputDecoration(
                              hintText: 'YouTube/Vimeo Link',
                              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                              prefixIcon: const Icon(Icons.videocam, color: Color(0xFFD1D5DB), size: 16),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          const Text('Detailed Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Goals, workload, and target audience...',
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

                    const SizedBox(height: 24),

                    // 3. Pricing & Duration
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
                              Text('PRICING & DURATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
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
                                      controller: _priceController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        hintText: '199.99',
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
                                    const Text('Duration', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                    const SizedBox(height: 6),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _durationController,
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                hintText: '12',
                                                hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.all(16),
                                              ),
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: DropdownButton<String>(
                                              value: _durationUnit,
                                              underline: const SizedBox(),
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black),
                                              items: const [
                                                DropdownMenuItem(value: 'Weeks', child: Text('WEEKS')),
                                                DropdownMenuItem(value: 'Sessions', child: Text('SESSIONS')),
                                                DropdownMenuItem(value: 'Months', child: Text('MONTHS')),
                                              ],
                                              onChanged: (value) => setState(() => _durationUnit = value!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Max Clients', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                    const SizedBox(height: 6),
                                    TextField(
                                      controller: _maxClientsController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Unlimited',
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
                                    const Text('End Date', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                    const SizedBox(height: 6),
                                    TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: 'Select Date',
                                        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                                        filled: true,
                                        fillColor: const Color(0xFFF9FAFB),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                        contentPadding: const EdgeInsets.all(16),
                                      ),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                      onTap: () async {
                                        await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2030),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    InkWell(
                      onTap: _isPublishing ? null : _handleSubmit,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _isPublishing ? const Color(0xFFA7F3D0) : const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: Text(
                          _isPublishing ? 'PUBLISHING...' : 'PUBLISH PROGRAM',
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
    );
  }
}
