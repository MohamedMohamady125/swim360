import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swim360/core/services/academy_service.dart';
import 'package:swim360/core/models/academy_models.dart';
import 'package:intl/intl.dart';

class MySwimmersScreen extends StatefulWidget {
  const MySwimmersScreen({Key? key}) : super(key: key);

  @override
  State<MySwimmersScreen> createState() => _MySwimmersScreenState();
}

class _MySwimmersScreenState extends State<MySwimmersScreen> {
  final AcademyService _academyService = AcademyService();

  String? _selectedBranch;
  String _searchQuery = '';
  AcademySwimmer? _selectedSwimmer;

  bool _isLoading = false;
  String? _errorMessage;

  List<AcademySwimmer> _swimmers = [];
  List<AcademyBranch> _branches = [];
  List<AcademyProgram> _programs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final swimmers = await _academyService.getMySwimmers();
      final branches = await _academyService.getMyBranches();
      final programs = await _academyService.getMyPrograms();

      if (mounted) {
        setState(() {
          _swimmers = swimmers;
          _branches = branches;
          _programs = programs;
          _isLoading = false;

          // Set default branch if available
          if (_branches.isNotEmpty && _selectedBranch == null) {
            _selectedBranch = _branches.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data: $e';
          _isLoading = false;
        });
      }
    }
  }

  String _getProgramName(String? programId) {
    if (programId == null) return 'No Program';
    try {
      final program = _programs.firstWhere((p) => p.id == programId);
      return program.name;
    } catch (e) {
      return 'Unknown Program';
    }
  }

  String _getInitial(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  List<AcademySwimmer> get filteredSwimmers {
    return _swimmers.where((s) {
      final matchesBranch = _selectedBranch == null || s.branchId == _selectedBranch;
      final matchesSearch = s.swimmerName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesBranch && matchesSearch;
    }).toList();
  }

  Map<String, List<AcademySwimmer>> get groupedSwimmers {
    final filtered = filteredSwimmers;
    final Map<String, List<AcademySwimmer>> groups = {};
    for (var swimmer in filtered) {
      final programName = _getProgramName(swimmer.programId);
      groups.putIfAbsent(programName, () => []).add(swimmer);
    }
    return groups;
  }

  void _openModal(AcademySwimmer swimmer) {
    setState(() => _selectedSwimmer = swimmer);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(swimmer),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _swimmers.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading swimmers...'),
            ],
          ),
        ),
      );
    }

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
                  onPressed: _loadData,
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
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildBranchFilter(),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildSwimmersList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: const Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SWIMMERS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      fontStyle: FontStyle.italic,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ENROLLMENT ROSTER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9CA3AF),
                      letterSpacing: 2.5,
                    ),
                  ),
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
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: const Icon(Icons.people_outline, color: Color(0xFF2563EB), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'SELECT BRANCH',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF94A3B8),
              letterSpacing: 2.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.business_outlined, color: const Color(0xFF9CA3AF), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBranch,
                    onChanged: (value) => setState(() => _selectedBranch = value),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
                    items: _branches.map((branch) => DropdownMenuItem(
                      value: branch.id,
                      child: Text(branch.name),
                    )).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.search, color: const Color(0xFFD1D5DB), size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: 'SEARCH SWIMMER NAMES...',
                hintStyle: TextStyle(color: const Color(0xFFD1D5DB), fontSize: 14, fontWeight: FontWeight.w700),
                border: InputBorder.none,
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwimmersList() {
    final groups = groupedSwimmers;

    if (groups.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Text(
          'NO SWIMMERS FOUND',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFD1D5DB),
            letterSpacing: 2.5,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: groups.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      '${entry.key.toUpperCase()} — ${entry.value.length} SWIMMERS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFCBD5E1),
                        letterSpacing: 2.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Container(height: 1, color: const Color(0xFFF1F5F9))),
                  ],
                ),
              ),
              ...entry.value.map((swimmer) => _buildSwimmerCard(swimmer)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwimmerCard(AcademySwimmer swimmer) {
    final initial = _getInitial(swimmer.swimmerName);
    final endDateStr = swimmer.endDate != null
        ? DateFormat('MMM d, yyyy').format(swimmer.endDate!)
        : 'No end date';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => _openModal(swimmer),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
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
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2563EB),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      swimmer.swimmerName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        fontStyle: FontStyle.italic,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'END DATE: $endDateStr',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF60A5FA),
                        letterSpacing: 2.5,
                      ),
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
                child: const Icon(Icons.arrow_forward_ios, color: Color(0xFFD1D5DB), size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModal(AcademySwimmer swimmer) {
    final initial = _getInitial(swimmer.swimmerName);
    final programName = _getProgramName(swimmer.programId);
    final endDateStr = swimmer.endDate != null
        ? DateFormat('MMM d, yyyy').format(swimmer.endDate!)
        : 'No end date';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(44)),
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2563EB),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            swimmer.swimmerName.toUpperCase(),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              fontStyle: FontStyle.italic,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            programName.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2563EB),
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 2.5,
                      ),
                    ),
                    Text(
                      'ACTIVE ENROLLMENT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF10B981),
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: const Color(0xFFE5E7EB).withOpacity(0.5)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PROGRAM END',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 2.5,
                      ),
                    ),
                    Text(
                      endDateStr,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFF43F5E),
                        letterSpacing: 2.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (swimmer.phone != null)
            ElevatedButton(
              onPressed: () async {
                final cleanPhone = swimmer.phone!.replaceAll('+', '');
                final url = Uri.parse('https://wa.me/$cleanPhone');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'MESSAGE SWIMMER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
