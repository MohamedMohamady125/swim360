import 'package:flutter/material.dart';

class MyProgramsScreen extends StatefulWidget {
  const MyProgramsScreen({super.key});

  @override
  State<MyProgramsScreen> createState() => _MyProgramsScreenState();
}

class _MyProgramsScreenState extends State<MyProgramsScreen> {
  List<Program> _programs = [
    Program(
      id: 'prog1',
      title: '12-Week Stroke Mastery',
      price: 199.99,
      duration: '12 Weeks',
      endDate: '2026-12-31',
      photoUrl: 'https://images.unsplash.com/photo-1530549387634-e5a529577059?auto=format&fit=crop&q=80&w=800',
      description: 'Comprehensive stroke mastery curriculum.',
    ),
    Program(
      id: 'prog2',
      title: 'Nutrition for Triathletes',
      price: 49.00,
      duration: '8 Sessions',
      endDate: '',
      photoUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=800',
      description: 'Fueling endurance athletes.',
    ),
  ];

  Program? _editingProgram;
  bool _showModal = false;

  void _openEditModal(Program program) {
    setState(() {
      _editingProgram = Program(
        id: program.id,
        title: program.title,
        price: program.price,
        duration: program.duration,
        endDate: program.endDate,
        photoUrl: program.photoUrl,
        description: program.description,
      );
      _showModal = true;
    });
  }

  void _handleSave(String description, String endDate) {
    setState(() {
      final index = _programs.indexWhere((p) => p.id == _editingProgram!.id);
      _programs[index].description = description;
      _programs[index].endDate = endDate;
      _showModal = false;
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
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
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
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                              ),
                              child: const Icon(Icons.arrow_back_ios_new, size: 24),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MY PROGRAMS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                              SizedBox(height: 2),
                              Text('OFFICIAL INVENTORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                ),

                // Program List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: _programs.length,
                    itemBuilder: (context, index) {
                      final program = _programs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () => _openEditModal(program),
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.network(
                                    program.photoUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(program.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                                      const SizedBox(height: 4),
                                      Text('\$${program.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${program.duration} ${program.endDate.isNotEmpty ? '• Ends ${program.endDate}' : '• Ongoing'}',
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.edit, color: Color(0xFF9CA3AF), size: 20),
                                ),
                              ],
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

          // Edit Modal
          if (_showModal && _editingProgram != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showModal = false),
                child: Container(
                  color: const Color(0xFF0F172A).withOpacity(0.6),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))],
                        ),
                        child: _EditForm(
                          program: _editingProgram!,
                          onSave: _handleSave,
                          onClose: () => setState(() => _showModal = false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EditForm extends StatefulWidget {
  final Program program;
  final Function(String description, String endDate) onSave;
  final VoidCallback onClose;

  const _EditForm({
    required this.program,
    required this.onSave,
    required this.onClose,
  });

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  late TextEditingController _descriptionController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.program.description);
    _endDateController = TextEditingController(text: widget.program.endDate);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('EDIT DETAILS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            InkWell(
              onTap: widget.onClose,
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
        const SizedBox(height: 8),
        Text(widget.program.title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB), letterSpacing: 3.0)),
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Detailed Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Campaign End Date', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.0)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _endDateController,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF9CA3AF), size: 16),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              _endDateController.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            }
          },
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: () => widget.onSave(_descriptionController.text, _endDateController.text),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: const Text(
              'SAVE CHANGES',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}

class Program {
  final String id;
  final String title;
  final double price;
  final String duration;
  String endDate;
  final String photoUrl;
  String description;

  Program({
    required this.id,
    required this.title,
    required this.price,
    required this.duration,
    required this.endDate,
    required this.photoUrl,
    required this.description,
  });
}
