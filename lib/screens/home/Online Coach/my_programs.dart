import 'package:flutter/material.dart';

class Program {
    String id;
    String title;
    double price;
    int durationValue;
    String durationUnit;
    String? endDate; // ISO yyyy-mm-dd or null
    String? videoUrl;
    String photoUrl;
    String description;

    Program({
        required this.id,
        required this.title,
        required this.price,
        required this.durationValue,
        required this.durationUnit,
        this.endDate,
        this.videoUrl,
        required this.photoUrl,
        required this.description,
    });
}

class MyProgramsScreen extends StatefulWidget {
    const MyProgramsScreen({Key? key}) : super(key: key);

    @override
    State<MyProgramsScreen> createState() => _MyProgramsScreenState();
}

class _MyProgramsScreenState extends State<MyProgramsScreen> {
    final List<Program> _programs = [
        Program(
            id: 'prog1',
            title: '12-Week Stroke Mastery',
            price: 199.99,
            durationValue: 12,
            durationUnit: 'weeks',
            endDate: '2024-12-31',
            videoUrl: 'https://youtube.com/mastery',
            photoUrl: 'https://placehold.co/400x160/2563eb/ffffff?text=STROKE+MASTERY',
            description: 'Comprehensive training plan focused on maximizing efficiency across all four strokes.',
        ),
        Program(
            id: 'prog2',
            title: 'Nutrition for Triathletes',
            price: 49.00,
            durationValue: 8,
            durationUnit: 'sessions',
            endDate: null,
            videoUrl: 'https://vimeo.com/tri-nutri',
            photoUrl: 'https://placehold.co/400x160/10b981/ffffff?text=NUTRITION+PLAN',
            description: 'Learn how to fuel your body correctly for endurance events with weekly video modules.',
        ),
        Program(
            id: 'prog3',
            title: 'Beginner Open Water Prep',
            price: 99.50,
            durationValue: 4,
            durationUnit: 'weeks',
            endDate: '2024-10-15',
            videoUrl: null,
            photoUrl: 'https://placehold.co/400x160/f97316/ffffff?text=OPEN+WATER+PREP',
            description: 'A four-week guide to transitioning from pool swimming to open water confidence.',
        ),
    ];

    // Controllers for the edit form
    final _descCtrl = TextEditingController();
    final _videoCtrl = TextEditingController();
    DateTime? _selectedEndDate;
    String? _editingProgramId;
    bool _saving = false;

    @override
    void dispose() {
        _descCtrl.dispose();
        _videoCtrl.dispose();
        super.dispose();
    }

    void _openEditSheet(Program program) async {
        _editingProgramId = program.id;
        _descCtrl.text = program.description;
        _videoCtrl.text = program.videoUrl ?? '';
        _selectedEndDate = program.endDate != null ? DateTime.tryParse(program.endDate!) : null;

        await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            builder: (context) {
                return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Center(child: Container(height: 6, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))) ,
                            const SizedBox(height: 12),
                            Text('Edit Program: ${program.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            TextField(controller: _descCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Detailed Description', border: OutlineInputBorder())),
                            const SizedBox(height: 12),
                            TextField(controller: _videoCtrl, decoration: const InputDecoration(labelText: 'Intro Video URL (Optional)', border: OutlineInputBorder())),
                            const SizedBox(height: 12),
                            Row(children: [
                                Expanded(
                                    child: OutlinedButton.icon(
                                        onPressed: () async {
                                            final now = DateTime.now();
                                            final picked = await showDatePicker(context: context, initialDate: _selectedEndDate ?? now, firstDate: now, lastDate: DateTime(now.year + 5));
                                            if (picked != null) setState(() => _selectedEndDate = picked);
                                        },
                                        icon: const Icon(Icons.calendar_today_outlined),
                                        label: Text(_selectedEndDate == null ? 'Select End Date (optional)' : 'End: ${_selectedEndDate!.toLocal().toString().split(' ')[0]}'),
                                    ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(onPressed: () => setState(() => _selectedEndDate = null), icon: const Icon(Icons.clear)),
                            ]),
                            const SizedBox(height: 16),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: _saving ? null : () async {
                                        // Validate end date
                                        if (_selectedEndDate != null && _selectedEndDate!.isBefore(DateTime.now())) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End date cannot be in the past.')));
                                            return;
                                        }

                                        setState(() => _saving = true);
                                        await Future.delayed(const Duration(milliseconds: 500));

                                        final idx = _programs.indexWhere((p) => p.id == _editingProgramId);
                                        if (idx != -1) {
                                            setState(() {
                                                _programs[idx].description = _descCtrl.text.trim();
                                                _programs[idx].videoUrl = _videoCtrl.text.trim().isEmpty ? null : _videoCtrl.text.trim();
                                                _programs[idx].endDate = _selectedEndDate == null ? null : _selectedEndDate!.toIso8601String().split('T')[0];
                                            });
                                            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Changes saved for: ${_programs[idx].title}')));
                                        }

                                        setState(() => _saving = false);
                                        Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        child: Text(_saving ? 'Saving...' : 'Save Changes'),
                                    ),
                                ),
                            ),
                            const SizedBox(height: 12),
                        ]),
                    ),
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('My Programs')),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                        const Align(alignment: Alignment.centerLeft, child: Text('Manage your live and self-paced coaching programs.', style: TextStyle(color: Colors.black54))),
                        const SizedBox(height: 12),
                        Expanded(
                            child: ListView.builder(
                                itemCount: _programs.length,
                                itemBuilder: (context, index) {
                                    final prog = _programs[index];
                                    return Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 2,
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        child: InkWell(
                                            borderRadius: BorderRadius.circular(12),
                                            onTap: () {},
                                            child: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Row(children: [
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: Image.network(prog.photoUrl, width: 110, height: 60, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 110, height: 60, color: Colors.grey[300])),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Text(prog.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                            const SizedBox(height: 4),
                                                            Text('\$${prog.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),
                                                            const SizedBox(height: 6),
                                                            Text('Duration: ${prog.durationValue} ${prog.durationUnit} ${prog.endDate != null ? '| Ends: ${prog.endDate}' : ''}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                                        ]),
                                                    ),
                                                    IconButton(onPressed: () => _openEditSheet(prog), icon: const Icon(Icons.edit, color: Colors.blue)),
                                                ]),
                                            ),
                                        ),
                                    );
                                },
                            ),
                        ),
                    ]),
                ),
            ),
        );
    }
}
