import 'package:flutter/material.dart';

class BookAcademyScreen extends StatefulWidget {
  const BookAcademyScreen({super.key});

  @override
  State<BookAcademyScreen> createState() => _BookAcademyScreenState();
}

class _BookAcademyScreenState extends State<BookAcademyScreen> {
  int _currentStep = 0;
  Academy? _selectedAcademy;
  Branch? _selectedBranch;

  final List<Academy> _academies = [];

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
        child: Column(
          children: [
            _buildHeader(),
            _buildStepper(),
            Expanded(child: _buildCurrentStep()),
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
                  Text('ENROLL', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                  Text('ACADEMY PORTAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                ],
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFDCEEFE)),
            ),
            child: const Icon(Icons.emoji_events, color: Color(0xFF2563EB), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = ['Academy', 'Branch', 'Level'];
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
            color: isActive ? const Color(0xFF2563EB) : Colors.white,
            border: Border.all(color: isActive ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9), width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('${step + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isActive ? Colors.white : const Color(0xFF9CA3AF))),
          ),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF), letterSpacing: 2.0)),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: _currentStep > step ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildAcademyList();
      case 1:
        return _buildBranchList();
      case 2:
        return _buildConfirmation();
      default:
        return const SizedBox();
    }
  }

  Widget _buildAcademyList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _academies.length,
      itemBuilder: (context, index) {
        final academy = _academies[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedAcademy = academy;
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
                        Image.network(academy.image, height: 240, width: double.infinity, fit: BoxFit.cover),
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
                              Text(academy.name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
                              const SizedBox(height: 4),
                              Text(academy.area.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFDEF3FF).withOpacity(0.9), letterSpacing: 2.5)),
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
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.school, color: Color(0xFF2563EB), size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Text('ENROLLMENT OPEN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 10)],
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

  Widget _buildBranchList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _selectedAcademy!.branches.length,
      itemBuilder: (context, index) {
        final branch = _selectedAcademy!.branches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedBranch = branch;
                _currentStep = 2;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDCEEFE)),
                    ),
                    child: const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(branch.name.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(branch.address, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmation() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FINAL STEP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text('Programs at ${_selectedBranch!.name}'.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 2.5)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 20))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ACADEMY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFD1D5DB), letterSpacing: 2.5)),
                const SizedBox(height: 4),
                Text(_selectedAcademy!.name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SUBSCRIPTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          SizedBox(height: 4),
                          Text('\$120.00', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                        ],
                      ),
                      Icon(Icons.star, color: Color(0xFF2563EB), size: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('CONFIRM ENROLLMENT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Academy {
  final String id;
  final String name;
  final String area;
  final String image;
  final List<Branch> branches;
  final List<Program> programs;

  Academy({required this.id, required this.name, required this.area, required this.image, required this.branches, required this.programs});
}

class Branch {
  final String id;
  final String name;
  final String address;

  Branch({required this.id, required this.name, required this.address});
}

class Program {
  final String id;
  final String name;
  final double price;
  final String description;
  final int spots;

  Program({required this.id, required this.name, required this.price, required this.description, required this.spots});
}
