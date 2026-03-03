import 'package:flutter/material.dart';
import 'package:swim360/core/services/academy_service.dart';
import 'package:swim360/core/models/academy_models.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final AcademyService _academyService = AcademyService();
  List<AcademyBranch> _branches = [];
  Map<String, List<AcademyPool>> _branchPools = {};
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final branches = await _academyService.getMyBranches();

      // Load pools for each branch
      final Map<String, List<AcademyPool>> poolsMap = {};
      for (var branch in branches) {
        try {
          final pools = await _academyService.getBranchPools(branch.id);
          poolsMap[branch.id] = pools;
        } catch (e) {
          poolsMap[branch.id] = [];
        }
      }

      if (mounted) {
        setState(() {
          _branches = branches;
          _branchPools = poolsMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load branches: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)), backgroundColor: const Color(0xFF0F172A), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 40)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading && _branches.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading branches...'),
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
                  onPressed: _loadBranches,
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
                      Text('MY BRANCHES', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.0, fontStyle: FontStyle.italic, height: 1.0)),
                      const SizedBox(height: 8),
                      Text('MANAGEMENT HUB', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 3.0, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text('Manage academy locations, configure pools and lane capacities, and set operational hours for each branch.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF9CA3AF), letterSpacing: 2.5)),
              const SizedBox(height: 40),
              ..._branches.map((branch) => _buildBranchCard(branch)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchCard(AcademyBranch branch) {
    final pools = _branchPools[branch.id] ?? [];
    final totalLanes = pools.fold(0, (sum, p) => sum + p.lanes);
    final totalCapacity = pools.fold(0, (sum, p) => sum + p.capacity);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.name.toUpperCase(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5, fontStyle: FontStyle.italic, height: 1.0)),
                    const SizedBox(height: 12),
                    Text((branch.city ?? 'N/A').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF2563EB), letterSpacing: 3.0, fontStyle: FontStyle.italic)),
                  ],
                ),
                Row(
                  children: [
                    _buildActionButton(Icons.edit_outlined, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), () => _showEditModal(branch)),
                    const SizedBox(width: 8),
                    _buildActionButton(Icons.calendar_today_outlined, const Color(0xFF10B981), const Color(0xFFD1FAE5), () => _showDaysModal(branch)),
                    const SizedBox(width: 8),
                    _buildActionButton(Icons.waves, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), () => _showPoolsModal(branch)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('OPERATING HOURS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 2.5)), const SizedBox(height: 4), Text('${branch.openingTime ?? 'N/A'} - ${branch.closingTime ?? 'N/A'}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic))]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('POOLS / CAPACITY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 2.5)), const SizedBox(height: 4), Text('${pools.length} POOLS / $totalCapacity SWIMMERS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic))]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: const Color(0xFFCBD5E1)),
                const SizedBox(width: 12),
                Text('CONFIGURED FOR $totalLanes LANES ACROSS ALL POOLS.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFFCBD5E1), letterSpacing: 2.5, fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, Color bgColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  void _showEditModal(AcademyBranch branch) {
    final nameController = TextEditingController(text: branch.name);
    final urlController = TextEditingController(text: branch.locationUrl ?? '');
    final openController = TextEditingController(text: branch.openingTime ?? '');
    final closeController = TextEditingController(text: branch.closingTime ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(44))),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 48, height: 6, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 40),
            Text('EDIT ${branch.name.toUpperCase()}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'BRANCH NAME', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
            const SizedBox(height: 16),
            TextField(controller: urlController, decoration: InputDecoration(labelText: 'LOCATION URL', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
            const SizedBox(height: 16),
            Row(children: [Expanded(child: TextField(controller: openController, decoration: InputDecoration(labelText: 'OPEN TIME', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))))), const SizedBox(width: 12), Expanded(child: TextField(controller: closeController, decoration: InputDecoration(labelText: 'CLOSE TIME', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))))]),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                try {
                  final data = {
                    'name': nameController.text,
                    'location_url': urlController.text,
                    'opening_time': openController.text,
                    'closing_time': closeController.text,
                  };

                  await _academyService.updateBranch(branch.id, data);
                  await _loadBranches();

                  if (mounted) {
                    Navigator.pop(context);
                    _showSnackbar('Branch details updated.');
                  }
                } catch (e) {
                  _showSnackbar('Failed to update branch: $e');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), minimumSize: const Size(double.infinity, 0)),
              child: Text('SAVE CHANGES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPoolsModal(AcademyBranch branch) {
    final pools = _branchPools[branch.id] ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(44))),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 48, height: 6, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('POOLS & LANES', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)), IconButton(icon: Icon(Icons.add_circle_outline, color: const Color(0xFF2563EB)), onPressed: () async {
                try {
                  final data = {
                    'branch_id': branch.id,
                    'name': 'New Pool',
                    'lanes': 6,
                    'capacity': 30,
                  };
                  await _academyService.createPool(data);
                  await _loadBranches();
                  setModalState(() {});
                  setState(() {});
                } catch (e) {
                  _showSnackbar('Failed to create pool: $e');
                }
              })]),
              const SizedBox(height: 24),
              ...pools.map((pool) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20), border: Border(left: BorderSide(color: const Color(0xFF3B82F6), width: 4))),
                child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(pool.name.toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)), IconButton(icon: Icon(Icons.close, size: 20, color: const Color(0xFFCBD5E1)), onPressed: () async {
                  try {
                    await _academyService.deletePool(pool.id);
                    await _loadBranches();
                    setModalState(() {});
                    setState(() {});
                  } catch (e) {
                    _showSnackbar('Failed to delete pool: $e');
                  }
                })]), const SizedBox(height: 12), Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('LANES', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 2.5)), Text('${pool.lanes}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF2563EB)))])), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('MAX CAP', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: const Color(0xFF94A3B8), letterSpacing: 2.5)), Text('${pool.capacity}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF2563EB)))]))])]),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showDaysModal(AcademyBranch branch) {
    final days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final selectedDays = List<String>.from(branch.operatingDays ?? []);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(44))),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 48, height: 6, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 40),
              Text('OPERATIONAL DAYS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Text('SELECT BRANCH AVAILABILITY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8), letterSpacing: 2.5)),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: days.map((day) => InkWell(
                  onTap: () => setModalState(() => selectedDays.contains(day) ? selectedDays.remove(day) : selectedDays.add(day)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(color: selectedDays.contains(day) ? const Color(0xFF3B82F6) : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14), boxShadow: selectedDays.contains(day) ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))] : []),
                    child: Text(day.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: selectedDays.contains(day) ? Colors.white : const Color(0xFF94A3B8), letterSpacing: 0.5)),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final data = {'operating_days': selectedDays};
                    await _academyService.updateBranch(branch.id, data);
                    await _loadBranches();

                    if (mounted) {
                      Navigator.pop(context);
                      _showSnackbar('Operational days updated.');
                    }
                  } catch (e) {
                    _showSnackbar('Failed to update days: $e');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), minimumSize: const Size(double.infinity, 0)),
                child: Text('CONFIRM DAYS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
