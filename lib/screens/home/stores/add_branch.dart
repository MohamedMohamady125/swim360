import 'package:flutter/material.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({super.key});

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final List<String> governorates = ["Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", "Gharbia", "Ismailia", "Luxor", "Matrouh", "Minya", "Monufia", "New Valley", "North Sinai", "Port Said", "Qalyubia", "Qena", "Sharqia", "Sohag", "South Sinai", "Suez"];

  String _governorate = 'Cairo';
  String _city = '';
  String _locationName = '';
  String _locationUrl = '';
  String _branchPhone = '';
  String _openingHour = '08';
  String _openingMinute = '00';
  String _openingAmpm = 'AM';
  String _closingHour = '05';
  String _closingMinute = '00';
  String _closingAmpm = 'PM';
  String _deliveryTimeRange = '';
  bool _isLoading = false;

  void _handleSubmit() {
    if (_city.isEmpty || _locationName.isEmpty || _branchPhone.isEmpty || _deliveryTimeRange.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Color(0xFFEF4444)),
      );
      return;
    }

    final rangePattern = RegExp(r'^\d+(-\d+)?$');
    if (!rangePattern.hasMatch(_deliveryTimeRange)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid range (e.g. 3 or 3-5)'), backgroundColor: Color(0xFFEF4444)),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Branch Registered Successfully!'), backgroundColor: Color(0xFF1F2937)),
      );
    });
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
                        child: const Icon(Icons.business, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register Branch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                          SizedBox(height: 2),
                          Text('STORE EXPANSION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 24)),
                ],
              ),
            ),

            // Form
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
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
                        const Row(children: [Icon(Icons.location_on, color: Color(0xFF2563EB), size: 16), SizedBox(width: 8), Text('LOCATION DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0))]),
                        const SizedBox(height: 20),
                        const Text('Governorate', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)),
                          child: DropdownButton<String>(
                            value: _governorate,
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                            items: governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                            onChanged: (val) => setState(() => _governorate = val!),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('City', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 6),
                        TextField(
                          onChanged: (val) => setState(() => _city = val),
                          decoration: InputDecoration(hintText: 'e.g. Maadi or Nasr City', hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)), filled: true, fillColor: const Color(0xFFF9FAFB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16)),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        const Text('Store Location Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 6),
                        TextField(
                          onChanged: (val) => setState(() => _locationName = val),
                          decoration: InputDecoration(hintText: 'e.g. Red Sea Mall Branch', hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)), filled: true, fillColor: const Color(0xFFF9FAFB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16)),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        const Text('Google Maps URL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 6),
                        TextField(
                          onChanged: (val) => setState(() => _locationUrl = val),
                          decoration: InputDecoration(
                            hintText: 'Paste link here...',
                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                            prefixIcon: const Icon(Icons.navigation, color: Color(0xFFD1D5DB), size: 16),
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
                  const SizedBox(height: 16),

                  // 2. Contact & Hours
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [Icon(Icons.access_time, color: Color(0xFF2563EB), size: 16), SizedBox(width: 8), Text('OPERATIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0))]),
                        const SizedBox(height: 20),
                        const Text('Branch Phone Number', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 6),
                        TextField(
                          onChanged: (val) => setState(() => _branchPhone = val),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '+20',
                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                            prefixIcon: const Icon(Icons.phone, color: Color(0xFFD1D5DB), size: 16),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 20),
                        _buildTimeSelector('Opening Time', 'opening'),
                        const SizedBox(height: 16),
                        _buildTimeSelector('Closing Time', 'closing'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Fulfillment
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [Icon(Icons.local_shipping, color: Color(0xFF2563EB), size: 16), SizedBox(width: 8), Text('FULFILLMENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0))]),
                        const SizedBox(height: 16),
                        const Text('Delivery Time Range (Days)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 6),
                        TextField(
                          onChanged: (val) => setState(() => _deliveryTimeRange = val),
                          decoration: InputDecoration(hintText: 'e.g. 3 or 3-5', hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)), filled: true, fillColor: const Color(0xFFF9FAFB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(16)),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        const Text('Accepts a single number or a range separated by a hyphen.', style: TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  InkWell(
                    onTap: _isLoading ? null : _handleSubmit,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: _isLoading ? const Color(0xFF9CA3AF) : const Color(0xFF2563EB), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))]),
                      child: Center(child: Text(_isLoading ? 'REGISTERING...' : 'REGISTER BRANCH', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(String label, String prefix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                child: DropdownButton<String>(
                  value: prefix == 'opening' ? _openingHour : _closingHour,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                  items: List.generate(12, (i) => (i + 1).toString().padLeft(2, '0')).map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                  onChanged: (val) => setState(() {
                    if (prefix == 'opening') {
                      _openingHour = val!;
                    } else {
                      _closingHour = val!;
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                child: DropdownButton<String>(
                  value: prefix == 'opening' ? _openingMinute : _closingMinute,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                  items: ["00", "15", "30", "45"].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (val) => setState(() {
                    if (prefix == 'opening') {
                      _openingMinute = val!;
                    } else {
                      _closingMinute = val!;
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(
                value: prefix == 'opening' ? _openingAmpm : _closingAmpm,
                underline: const SizedBox(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                items: ["AM", "PM"].map((ap) => DropdownMenuItem(value: ap, child: Text(ap))).toList(),
                onChanged: (val) => setState(() {
                  if (prefix == 'opening') {
                    _openingAmpm = val!;
                  } else {
                    _closingAmpm = val!;
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
