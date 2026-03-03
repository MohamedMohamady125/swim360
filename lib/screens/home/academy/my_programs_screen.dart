import 'package:flutter/material.dart';
import 'package:swim360/core/services/academy_service.dart';
import 'package:swim360/core/models/academy_models.dart';

class MyProgramsScreen extends StatefulWidget {
  const MyProgramsScreen({super.key});

  @override
  State<MyProgramsScreen> createState() => _MyProgramsScreenState();
}

class _MyProgramsScreenState extends State<MyProgramsScreen> {
  final AcademyService _academyService = AcademyService();
  List<AcademyProgram> programs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final fetchedPrograms = await _academyService.getMyPrograms();

      setState(() {
        programs = fetchedPrograms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load programs: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFF1F5F9)), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.arrow_back_ios_new, size: 24)),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MY PROGRAMS', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.0, fontStyle: FontStyle.italic, height: 1.0)),
                      const SizedBox(height: 8),
                      Text('TRAINING LEVELS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 3.0, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Text(_errorMessage!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadPrograms,
                          child: Text('RETRY'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (programs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('NO PROGRAMS YET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 2.5)),
                  ),
                )
              else
                ...programs.map((program) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF1F5F9))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(program.name.toUpperCase(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildStat('ENROLLED', program.enrolled.toString())),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStat('CAPACITY', program.capacity.toString())),
                            const SizedBox(width: 16),
                            Expanded(child: _buildStat('DURATION', program.duration ?? 'N/A')),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 2.0)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF2563EB))),
        ],
      ),
    );
  }
}
