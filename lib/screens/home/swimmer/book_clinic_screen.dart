import 'package:flutter/material.dart';
import 'package:swim360/core/services/clinic_service.dart';
import 'package:swim360/core/models/clinic_models.dart';

class BookClinicScreen extends StatefulWidget {
  const BookClinicScreen({super.key});

  @override
  State<BookClinicScreen> createState() => _BookClinicScreenState();
}

class _BookClinicScreenState extends State<BookClinicScreen> {
  final ClinicApiService _clinicService = ClinicApiService();

  int _currentStep = 0;
  Clinic? _selectedClinic;
  Branch? _selectedBranch;
  int _selectedDate = DateTime.now().day;
  int _selectedBed = 1;
  String? _selectedSlot;
  String? _selectedService;
  bool _isLoading = false;

  List<Clinic> _clinics = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      final results = await Future.wait([
        _clinicService.getAllClinics(),
        _clinicService.getAllBranches(),
        _clinicService.getAllServices(),
      ]);

      final clinics = results[0] as List<ClinicDetails>;
      final branches = results[1] as List<ClinicBranch>;
      final services = results[2] as List<ClinicService>;

      if (mounted) {
        setState(() {
          _clinics = clinics.map((c) {
            final clinicBranches = branches
                .where((b) => b.userId == c.userId)
                .map((b) {
                  final openHour = int.tryParse(b.openingHour ?? '8') ?? 8;
                  final closeHour = int.tryParse(b.closingHour ?? '18') ?? 18;
                  return Branch(
                    id: b.id,
                    name: b.locationName,
                    beds: b.numberOfBeds,
                    openHour: openHour,
                    closeHour: closeHour,
                  );
                })
                .toList();
            final clinicServices = services
                .where((s) => s.userId == c.userId)
                .map((s) => Service(
                      id: s.id,
                      name: s.title,
                      price: s.price,
                      duration: s.duration ?? '60 min',
                    ))
                .toList();
            return Clinic(
              id: c.userId,
              name: c.clinicName,
              image: '',
              branches: clinicBranches,
              services: clinicServices,
            );
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading clinic data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            if (_shouldShowFloatingButton()) _buildFloatingButton(),
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
                  Text('RECOVERY', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                  Text('BOOKING HUB', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
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
            child: const Icon(Icons.favorite, color: Color(0xFF2563EB), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = ['Clinic', 'Branch', 'Slot', 'Service'];
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
        return _buildClinicList();
      case 1:
        return _buildBranchList();
      case 2:
        return _buildSlotPicker();
      case 3:
        return _buildServiceList();
      default:
        return const SizedBox();
    }
  }

  Widget _buildClinicList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final colors = [const Color(0xFF2563EB), const Color(0xFF7C3AED), const Color(0xFF10B981), const Color(0xFFEF4444), const Color(0xFF0891B2)];
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _clinics.length,
      itemBuilder: (context, index) {
        final clinic = _clinics[index];
        final bgColor = colors[index % colors.length];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CLINICS', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                      SizedBox(height: 4),
                      Text('FIND A MEDICAL PROVIDER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 2.5)),
                    ],
                  ),
                ),
              ],
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedClinic = clinic;
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
                            Container(
                              height: 192,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [bgColor, Colors.black.withOpacity(0.8)],
                                ),
                              ),
                              child: Center(
                                child: Icon(Icons.medical_services, color: Colors.white.withOpacity(0.3), size: 80),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(clinic.name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
                                  const SizedBox(height: 4),
                                  Text('VERIFIED PARTNER', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFFDEF3FF).withOpacity(0.9), letterSpacing: 2.5)),
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
                                Icon(Icons.favorite, color: Color(0xFF2563EB), size: 16),
                                SizedBox(width: 8),
                                Text('4.9 RATING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 10)],
                              ),
                              child: const Text('CHOOSE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBranchList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _selectedClinic!.branches.length,
      itemBuilder: (context, index) {
        final branch = _selectedClinic!.branches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BRANCHES', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                      const SizedBox(height: 4),
                      Text(_selectedClinic!.name.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 2.5)),
                    ],
                  ),
                ),
              ],
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedBranch = branch;
                    _selectedBed = 1;
                    _selectedSlot = null;
                    _currentStep = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.business, color: Color(0xFF2563EB), size: 28),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(branch.name.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            const Text('VIEW AVAILABILITY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlotPicker() {
    final days = List.generate(14, (i) => DateTime.now().add(Duration(days: i)));
    final beds = List.generate(_selectedBranch!.beds, (i) => i + 1);
    final hours = List.generate(_selectedBranch!.closeHour - _selectedBranch!.openHour, (i) => _selectedBranch!.openHour + i);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final isSelected = _selectedDate == date.day;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => setState(() {
                      _selectedDate = date.day;
                      _selectedSlot = null;
                    }),
                    child: Container(
                      width: 56,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                        border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6), width: 2),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'][date.weekday % 7],
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF)),
                          ),
                          const SizedBox(height: 4),
                          Text('${date.day}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF))),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Bed selector
          const Text('SELECT BED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: beds.map((bed) {
                final isSelected = _selectedBed == bed;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() {
                      _selectedBed = bed;
                      _selectedSlot = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 8)] : null,
                      ),
                      child: Text(
                        'BED $bed',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : const Color(0xFF9CA3AF), letterSpacing: 2.5),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),

          // Time slots
          const Text('SELECT TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
          const SizedBox(height: 12),
          ...hours.map((hour) {
            final time = hour > 12 ? '${hour - 12}:00 PM' : '$hour:00 AM';
            final isSelected = _selectedSlot == time;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => setState(() => _selectedSlot = time),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                    border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6), width: 2),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.1), blurRadius: 10)] : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 8)] : null,
                        ),
                        child: Icon(Icons.access_time, color: isSelected ? Colors.white : const Color(0xFF9CA3AF), size: 20),
                      ),
                      const SizedBox(width: 16),
                      Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
                      const Spacer(),
                      if (isSelected)
                        const Icon(Icons.check, color: Color(0xFF2563EB), size: 20)
                      else
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _selectedClinic!.services.length,
      itemBuilder: (context, index) {
        final service = _selectedClinic!.services[index];
        final isSelected = _selectedService == service.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TREATMENT', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
                      const SizedBox(height: 4),
                      Text('${_selectedBranch!.name.toUpperCase()} • BED $_selectedBed', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB), letterSpacing: 2.5)),
                    ],
                  ),
                ),
              ],
              InkWell(
                onTap: () => setState(() => _selectedService = service.id),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                    border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6), width: 2),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.1), blurRadius: 20)] : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.healing, color: isSelected ? Colors.white : const Color(0xFF10B981), size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.name.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text('${service.duration} SESSION', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                          ],
                        ),
                      ),
                      Text('\$${service.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _shouldShowFloatingButton() {
    if (_currentStep == 2 && _selectedSlot != null) return true;
    if (_currentStep == 3 && _selectedService != null) return true;
    return false;
  }

  Widget _buildFloatingButton() {
    final buttonText = _currentStep == 2 ? 'CONTINUE' : 'CHECKOUT';
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, -10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('PHASE FINAL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                SizedBox(height: 4),
                Text('PROCEED', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0)),
              ],
            ),
            InkWell(
              onTap: () async {
                if (_currentStep == 2) {
                  setState(() => _currentStep = 3);
                } else {
                  // Create booking
                  try {
                    setState(() => _isLoading = true);
                    final bookingData = {
                      'branch_id': _selectedBranch!.id,
                      'service_id': _selectedService,
                      'client_name': 'User', // You may want to get this from user profile
                      'booking_date': DateTime.now().toIso8601String().split('T')[0],
                      'booking_time': _selectedSlot ?? '09:00',
                      'bed_number': 'Bed-$_selectedBed',
                    };
                    await _clinicService.createBooking(bookingData);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking created successfully!'), backgroundColor: Color(0xFF10B981)),
                      );
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed: ${e.toString()}'), backgroundColor: const Color(0xFFEF4444)),
                      );
                    }
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    Text(buttonText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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

class Clinic {
  final String id;
  final String name;
  final String image;
  final List<Branch> branches;
  final List<Service> services;

  Clinic({required this.id, required this.name, required this.image, required this.branches, required this.services});
}

class Branch {
  final String id;
  final String name;
  final int beds;
  final int openHour;
  final int closeHour;

  Branch({required this.id, required this.name, required this.beds, required this.openHour, required this.closeHour});
}

class Service {
  final String id;
  final String name;
  final double price;
  final String duration;

  Service({required this.id, required this.name, required this.price, required this.duration});
}
