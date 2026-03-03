import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final List<String> brands = ["Speedo", "Arena", "TYR", "Finis", "Mizuno", "MP Michael Phelps", "Zoggs", "Aqua Sphere", "Other"];
  final List<String> categories = ["Cap", "Goggles", "Suit", "Kickboard", "Paddles", "Parachute", "Fins", "Snorkels", "Deflectors", "Apparel", "Other"];
  final List<String> sizes = ["XS", "S", "M", "L", "XL", "22", "24", "26", "28", "30", "32", "34", "36", "38", "40", "ONE SIZE", "OTHER"];
  final List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'code': const Color(0xFFEF4444)},
    {'name': 'Blue', 'code': const Color(0xFF3B82F6)},
    {'name': 'Yellow', 'code': const Color(0xFFFACC15)},
    {'name': 'Orange', 'code': const Color(0xFFF97316)},
    {'name': 'Gold', 'code': const Color(0xFFFFD700)},
    {'name': 'Green', 'code': const Color(0xFF10B981)},
    {'name': 'Black', 'code': const Color(0xFF000000)},
    {'name': 'White', 'code': const Color(0xFFFFFFFF)},
    {'name': 'Pink', 'code': const Color(0xFFEC4899)},
    {'name': 'Purple', 'code': const Color(0xFF8B5CF6)},
  ];
  final List<String> branches = ["Zamalek Main", "New Cairo Hub", "Alexandria Branch", "Giza Outlet"];

  String name = '';
  String price = '';
  String brand = 'Speedo';
  String category = 'Suit';
  String description = '';
  List<String> selectedSizes = [];
  List<String> selectedColors = [];
  List<String> selectedBranches = [];
  bool isSizeDropdownOpen = false;

  void _toggleSize(String size) {
    final isOneSize = size == 'ONE SIZE' || size == 'OTHER';
    setState(() {
      if (selectedSizes.contains(size)) {
        selectedSizes.remove(size);
      } else {
        if (isOneSize) {
          selectedSizes = [size];
        } else {
          selectedSizes.removeWhere((s) => s == 'ONE SIZE' || s == 'OTHER');
          selectedSizes.add(size);
        }
      }
    });
  }

  void _handleSubmit() {
    if (name.isEmpty || price.isEmpty || selectedSizes.isEmpty || selectedColors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields and variants'), backgroundColor: Color(0xFFEF4444)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product Published Successfully!'), backgroundColor: Color(0xFF1F2937)),
    );
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
                        child: const Icon(Icons.add, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add Product', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                          SizedBox(height: 2),
                          Text('OFFICIAL INVENTORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
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
                  // 1. General Information
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
                            Icon(Icons.layers, color: Color(0xFF2563EB), size: 16),
                            SizedBox(width: 8),
                            Text('GENERAL INFORMATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Product Title', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (val) => setState(() => name = val),
                          decoration: InputDecoration(
                            hintText: 'e.g. FINA Competition Suit',
                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Brand', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)),
                                    child: DropdownButton<String>(
                                      value: brand,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                      items: brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                                      onChanged: (val) => setState(() => brand = val!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Category', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)),
                                    child: DropdownButton<String>(
                                      value: category,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                                      items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                      onChanged: (val) => setState(() => category = val!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Base Price (\$)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (val) => setState(() => price = val),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        const Text('Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (val) => setState(() => description = val),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Enter materials, features, and care instructions...',
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
                  const SizedBox(height: 16),

                  // 2. Media Gallery
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
                            Icon(Icons.camera_alt, color: Color(0xFF2563EB), size: 16),
                            SizedBox(width: 8),
                            Text('MEDIA GALLERY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.add, color: Color(0xFF2563EB), size: 24),
                                    SizedBox(height: 4),
                                    Text('Add Photos\n(Max 10)', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF)), textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.solid),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.straighten, color: Color(0xFF9CA3AF), size: 24),
                                    SizedBox(height: 4),
                                    Text('Size Guide\n(Optional)', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF)), textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Variants
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
                            Icon(Icons.palette, color: Color(0xFF2563EB), size: 16),
                            SizedBox(width: 8),
                            Text('VARIANTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Available Sizes', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => setState(() => isSizeDropdownOpen = !isSizeDropdownOpen),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedSizes.isEmpty ? 'Choose Sizes' : '${selectedSizes.length} Sizes Selected',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: selectedSizes.isEmpty ? const Color(0xFF9CA3AF) : const Color(0xFF2563EB)),
                                ),
                                Icon(isSizeDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF9CA3AF)),
                              ],
                            ),
                          ),
                        ),
                        if (isSizeDropdownOpen)
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFF3F4F6)),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                            ),
                            child: Column(
                              children: sizes.map((size) {
                                final isSelected = selectedSizes.contains(size);
                                final isOneSize = size == 'ONE SIZE' || size == 'OTHER';
                                final isDisabled = !isOneSize && (selectedSizes.contains('ONE SIZE') || selectedSizes.contains('OTHER'));
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InkWell(
                                    onTap: isDisabled ? null : () => _toggleSize(size),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(size, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : Colors.black)),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.white : const Color(0xFFFFFFFF),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: isSelected ? Colors.white : const Color(0xFFE5E7EB), width: 2),
                                            ),
                                            child: isSelected ? const Icon(Icons.check, size: 16, color: Color(0xFF2563EB)) : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 20),
                        const Text('Color Palette', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: colors.map((color) {
                            final isSelected = selectedColors.contains(color['name']);
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedColors.remove(color['name']);
                                  } else {
                                    selectedColors.add(color['name']);
                                  }
                                });
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: color['code'],
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.white, width: 4),
                                  boxShadow: isSelected ? [const BoxShadow(color: Color(0xFF2563EB), blurRadius: 10)] : [const BoxShadow(color: Colors.black12, blurRadius: 4)],
                                ),
                                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Branch Stock Allocation
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
                            Icon(Icons.business, color: Color(0xFF2563EB), size: 16),
                            SizedBox(width: 8),
                            Text('BRANCH STOCK ALLOCATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...branches.map((branch) {
                          final isSelected = selectedBranches.contains(branch);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedBranches.remove(branch);
                                  } else {
                                    selectedBranches.add(branch);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent, width: isSelected ? 2 : 0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(branch, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF6B7280))),
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
                  const SizedBox(height: 32),

                  // Submit Button
                  InkWell(
                    onTap: _handleSubmit,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: const Center(
                        child: Text('PUBLISH TO INVENTORY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0)),
                      ),
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
}
