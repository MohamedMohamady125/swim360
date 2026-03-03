import 'package:flutter/material.dart';
import 'package:swim360/core/services/academy_service.dart';
import 'package:swim360/core/models/academy_models.dart';

class CoachesScreen extends StatefulWidget {
  const CoachesScreen({super.key});

  @override
  State<CoachesScreen> createState() => _CoachesScreenState();
}

class _CoachesScreenState extends State<CoachesScreen> {
  final AcademyService _academyService = AcademyService();

  List<AcademyCoach> _coaches = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCoaches();
  }

  Future<void> _loadCoaches() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final coaches = await _academyService.getMyCoaches();

      if (mounted) {
        setState(() {
          _coaches = coaches;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load coaches: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading && _coaches.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading coaches...'),
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
                  onPressed: _loadCoaches,
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
                      Text('MY COACHES', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.0, fontStyle: FontStyle.italic, height: 1.0)),
                      const SizedBox(height: 8),
                      Text('STAFF DIRECTORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 3.0, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Empty state
              if (_coaches.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(Icons.people_outline, size: 40, color: Color(0xFFE5E7EB)),
                      ),
                      const SizedBox(height: 16),
                      const Text('NO COACHES YET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                    ],
                  ),
                )
              else
                ..._coaches.map((coach) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF1F5F9))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coach.fullName.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        if (coach.specialization != null)
                          Text(coach.specialization!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 1.5)),
                        if (coach.specialization != null)
                          const SizedBox(height: 16),
                        if (coach.experienceYears != null)
                          Text('EXPERIENCE: ${coach.experienceYears} Years', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                        if (coach.bio != null) ...[
                          const SizedBox(height: 16),
                          Text(coach.bio!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
                        ],
                        if (coach.certifications != null && coach.certifications!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('CERTIFICATIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          const SizedBox(height: 8),
                          ...coach.certifications!.map((cert) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.verified, size: 12, color: Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                Text(cert, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                              ],
                            ),
                          )),
                        ],
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
}
