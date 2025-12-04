import 'package:flutter/material.dart';

class CreateProgramScreen extends StatefulWidget {
    const CreateProgramScreen({Key? key}) : super(key: key);

    @override
    State<CreateProgramScreen> createState() => _CreateProgramScreenState();
}

class _CreateProgramScreenState extends State<CreateProgramScreen> {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _introUrlController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _durationController = TextEditingController();
    final TextEditingController _maxController = TextEditingController();

    String _deliveryMethod = 'live';
    String _durationUnit = 'weeks';
    DateTime? _endDate;
    String? _coverFileName;
    bool _publishing = false;

    @override
    void dispose() {
        _titleController.dispose();
        _introUrlController.dispose();
        _descController.dispose();
        _priceController.dispose();
        _durationController.dispose();
        _maxController.dispose();
        super.dispose();
    }

    Future<void> _selectEndDate() async {
        final now = DateTime.now();
        final picked = await showDatePicker(
            context: context,
            initialDate: _endDate ?? now,
            firstDate: now,
            lastDate: DateTime(now.year + 5),
        );
        if (picked != null) setState(() => _endDate = picked);
    }

    // Mock file picker — replace with real image picker integration if desired
    Future<void> _pickCoverFile() async {
        final filename = await showDialog<String>(
            context: context,
            builder: (context) {
                final controller = TextEditingController();
                return AlertDialog(
                    title: const Text('Mock upload: enter file name'),
                    content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'cover.jpg')),
                    actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Set')),
                    ],
                );
            },
        );

        if (filename != null && filename.isNotEmpty) {
            setState(() => _coverFileName = filename);
            _showSnackbar('Selected: $filename');
        }
    }

    void _showSnackbar(String message, {bool error = false}) {
        final snack = SnackBar(content: Text(message), backgroundColor: error ? Colors.red : Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    Future<void> _submit() async {
        if (!_formKey.currentState!.validate()) return;

        if (_coverFileName == null) {
            _showSnackbar('Please select a cover photo.', error: true);
            return;
        }

        if (_endDate != null && _endDate!.isBefore(DateTime.now())) {
            _showSnackbar('End date cannot be in the past.', error: true);
            return;
        }

        setState(() => _publishing = true);
        await Future.delayed(const Duration(seconds: 1));

        setState(() => _publishing = false);
        _showSnackbar('Successfully created program: ${_titleController.text}');

        // Reset the form (mock)
        _formKey.currentState!.reset();
        setState(() {
            _coverFileName = null;
            _deliveryMethod = 'live';
            _durationUnit = 'weeks';
            _endDate = null;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Create New Program')),
            body: SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Build New Program', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Define the curriculum, media, and pricing for your professional online coaching service.'),
                            const SizedBox(height: 18),

                            // Program details card
                            Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                                            Text('Program Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ]),
                                        const SizedBox(height: 12),
                                        TextFormField(
                                            controller: _titleController,
                                            decoration: const InputDecoration(labelText: 'Program Title', hintText: 'e.g., Elite Performance Coaching'),
                                            validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                                        ),
                                        const SizedBox(height: 12),
                                        DropdownButtonFormField<String>(
                                            value: _deliveryMethod,
                                            items: const [
                                                DropdownMenuItem(value: 'live', child: Text('Live / Scheduled Sessions')),
                                                DropdownMenuItem(value: 'self-paced', child: Text('Self-Paced (Video/Content Only)')),
                                                DropdownMenuItem(value: 'hybrid', child: Text('Hybrid (Content + Check-ins)')),
                                            ],
                                            onChanged: (v) => setState(() => _deliveryMethod = v ?? 'live'),
                                            decoration: const InputDecoration(labelText: 'Delivery Method'),
                                        ),
                                    ]),
                                ),
                            ),
                            const SizedBox(height: 14),

                            // Media & description
                            Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                                            Text('Media & Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ]),
                                        const SizedBox(height: 12),
                                        GestureDetector(
                                            onTap: _pickCoverFile,
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                                                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10), color: Colors.grey.shade50),
                                                child: Column(children: [
                                                    const Icon(Icons.image_outlined, size: 36, color: Colors.grey),
                                                    const SizedBox(height: 6),
                                                    Text(_coverFileName ?? 'Upload Cover Photo', style: TextStyle(color: _coverFileName == null ? Colors.grey.shade600 : Colors.green.shade700)),
                                                ]),
                                            ),
                                        ),
                                        const SizedBox(height: 12),
                                        TextFormField(
                                            controller: _introUrlController,
                                            decoration: const InputDecoration(labelText: 'Intro Video URL (Optional)', hintText: 'https://youtube.com/...'),
                                            keyboardType: TextInputType.url,
                                        ),
                                        const SizedBox(height: 12),
                                        TextFormField(
                                            controller: _descController,
                                            decoration: const InputDecoration(labelText: 'Detailed Description'),
                                            maxLines: 4,
                                            validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a description' : null,
                                        ),
                                    ]),
                                ),
                            ),
                            const SizedBox(height: 14),

                            // Pricing & duration
                            Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                                            Text('Pricing & Duration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ]),
                                        const SizedBox(height: 12),
                                        Row(children: [
                                            Expanded(
                                                child: TextFormField(
                                                    controller: _priceController,
                                                    decoration: const InputDecoration(labelText: 'Price (USD)', prefixText: '\$'),
                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter price' : null,
                                                ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: TextFormField(
                                                    controller: _durationController,
                                                    decoration: const InputDecoration(labelText: 'Duration'),
                                                    keyboardType: TextInputType.number,
                                                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter duration' : null,
                                                ),
                                            ),
                                        ]),
                                        const SizedBox(height: 12),
                                        Row(children: [
                                            Expanded(
                                                child: DropdownButtonFormField<String>(
                                                    value: _durationUnit,
                                                    items: const [
                                                        DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                                                        DropdownMenuItem(value: 'sessions', child: Text('Sessions')),
                                                        DropdownMenuItem(value: 'days', child: Text('Days')),
                                                        DropdownMenuItem(value: 'months', child: Text('Months')),
                                                    ],
                                                    onChanged: (v) => setState(() => _durationUnit = v ?? 'weeks'),
                                                    decoration: const InputDecoration(labelText: 'Duration Unit'),
                                                ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: TextFormField(
                                                    controller: _maxController,
                                                    decoration: const InputDecoration(labelText: 'Max Participants (optional)'),
                                                    keyboardType: TextInputType.number,
                                                ),
                                            ),
                                        ]),
                                        const SizedBox(height: 12),
                                        Row(children: [
                                            Expanded(
                                                child: OutlinedButton.icon(
                                                    onPressed: _selectEndDate,
                                                    icon: const Icon(Icons.calendar_today_outlined),
                                                    label: Text(_endDate == null ? 'Select End Date (optional)' : 'End: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                                                ),
                                            ),
                                        ]),
                                    ]),
                                ),
                            ),

                            const SizedBox(height: 18),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: _publishing ? null : _submit,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        child: Text(_publishing ? 'Publishing...' : 'Publish Program'),
                                    ),
                                ),
                            ),
                            const SizedBox(height: 24),
                        ]),
                    ),
                ),
            ),
        );
    }
}
