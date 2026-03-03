import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookOnlineCoachScreen extends StatefulWidget {
  const BookOnlineCoachScreen({super.key});

  @override
  State<BookOnlineCoachScreen> createState() => _BookOnlineCoachScreenState();
}

class _BookOnlineCoachScreenState extends State<BookOnlineCoachScreen> {
  int _currentStep = 0;
  Coach? _selectedCoach;
  Program? _selectedProgram;

  final List<Coach> _coaches = [];

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                _buildStepper(),
                Expanded(child: _buildCurrentStep()),
              ],
            ),
            if (_currentStep == 2 && _selectedProgram != null) _buildFloatingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                onTap: _handleBack,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('COACHES', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                  Text('ONLINE TRAINING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                ],
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEDE9FE)),
            ),
            child: const Icon(Icons.computer, color: Color(0xFF8B5CF6), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = ['Expert', 'Profile', 'Details'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length, (index) {
          return Row(
            children: [
              _buildStepIndicator(index, steps[index]),
              if (index < steps.length - 1) _buildStepLine(index),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF8B5CF6) : Colors.white,
            border: Border.all(color: isActive ? const Color(0xFF8B5CF6) : const Color(0xFFF1F5F9), width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('${step + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isActive ? Colors.white : const Color(0xFF9CA3AF))),
          ),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isActive ? const Color(0xFF8B5CF6) : const Color(0xFF9CA3AF), letterSpacing: 2.0)),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    return Container(
      width: 50,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: _currentStep > step ? const Color(0xFF8B5CF6) : const Color(0xFFF1F5F9),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildCoachList();
      case 1:
        return _buildCoachProfile();
      case 2:
        return _buildProgramDetails();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCoachList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _coaches.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF9CA3AF), size: 16),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Search online experts...', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
                  ),
                ],
              ),
            ),
          );
        }

        final coach = _coaches[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCoach = coach;
                _currentStep = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 20))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    child: Stack(
                      children: [
                        Image.network(coach.image, height: 240, width: double.infinity, fit: BoxFit.cover),
                        Container(
                          height: 240,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.8)],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(coach.name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
                              const SizedBox(height: 4),
                              Text(coach.specialty.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFE9D5FF).withOpacity(0.9), letterSpacing: 2.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Color(0xFF8B5CF6), size: 20),
                            SizedBox(width: 8),
                            Text('ENROLLMENT OPEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.3), blurRadius: 10)],
                          ),
                          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoachProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Transform.rotate(
                angle: 0.05,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(_selectedCoach!.image, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedCoach!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(_selectedCoach!.specialty.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF8B5CF6), fontStyle: FontStyle.italic, letterSpacing: 2.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EXPERT BIO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                const SizedBox(height: 16),
                Text(_selectedCoach!.bio, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF6B7280), height: 1.6)),
                const SizedBox(height: 24),
                Container(
                  height: 1,
                  color: const Color(0xFFF3F4F6),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () => _launchUrl('https://wa.me/20123456789'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFF25D366).withOpacity(0.3), blurRadius: 15)],
                    ),
                    child: const Text(
                      'WHATSAPP COACH',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text('CURRICULUM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
          ),
          const SizedBox(height: 16),
          ..._selectedCoach!.programs.map((program) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedProgram = program;
                    _currentStep = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.star, color: Color(0xFF8B5CF6), size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(program.title.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text('${program.duration} • ${program.goal}'.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          ],
                        ),
                      ),
                      Text('\$${program.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF8B5CF6))),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgramDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(_selectedProgram!.image, height: 256, width: double.infinity, fit: BoxFit.cover),
              Container(
                height: 256,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: InkWell(
                    onTap: () => _launchUrl(_selectedProgram!.videoUrl),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.4)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30)],
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_selectedProgram!.goal.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF8B5CF6), letterSpacing: 2.5)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('INSTANT ACCESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF10B981), letterSpacing: 2.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(_selectedProgram!.title.toUpperCase(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PROGRAM OVERVIEW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3.0)),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 16),
                        height: 1,
                        color: const Color(0xFFF3F4F6),
                      ),
                      Text(_selectedProgram!.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), height: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, -10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ENROLLMENT FEE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                const SizedBox(height: 4),
                Text('\$${_selectedProgram!.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
              ],
            ),
            InkWell(
              onTap: () {
                // Navigate to checkout
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: const Text('ENROLL NOW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Coach {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String image;
  final String bio;
  final List<Program> programs;

  Coach({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.bio,
    required this.programs,
  });
}

class Program {
  final String id;
  final String title;
  final double price;
  final String duration;
  final String goal;
  final String videoUrl;
  final String image;
  final String description;

  Program({
    required this.id,
    required this.title,
    required this.price,
    required this.duration,
    required this.goal,
    required this.videoUrl,
    required this.image,
    required this.description,
  });
}
