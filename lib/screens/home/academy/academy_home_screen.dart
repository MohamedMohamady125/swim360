import 'package:flutter/material.dart';
import 'package:swim360/core/services/storage_service.dart';
import 'package:swim360/screens/home/academy/add_program_screen.dart';
import 'package:swim360/screens/home/academy/my_programs_screen.dart';
import 'package:swim360/screens/home/academy/schedule_screen.dart';
import 'package:swim360/screens/home/academy/add_branch_screen.dart';
import 'package:swim360/screens/home/academy/branches_screen.dart';
import 'package:swim360/screens/home/academy/coaches_screen.dart';
import 'package:swim360/screens/home/academy/my_swimmers_screen.dart';

class AcademyHomeScreen extends StatefulWidget {
  const AcademyHomeScreen({Key? key}) : super(key: key);

  @override
  State<AcademyHomeScreen> createState() => _AcademyHomeScreenState();
}

class _AcademyHomeScreenState extends State<AcademyHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final StorageService _storageService = StorageService();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = await _storageService.getUser();
    if (mounted) {
      setState(() {
        _userName = user?.fullName ?? 'Academy Manager';
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      const SizedBox(height: 24),
                      _buildNotificationsBanner(),
                      const SizedBox(height: 16),
                      _buildMySwimmersBanner(),
                      const SizedBox(height: 24),
                      _buildActionGrid(),
                      const SizedBox(height: 32),
                      _buildManagementTools(),
                      const SizedBox(height: 80),
                    ],
                  ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Academy Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, ${_userName.isNotEmpty ? _userName : 'Academy Manager'}!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Coordinate your swimmers, coaches, and programs from one place.',
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsBanner() {
    return InkWell(
      onTap: () {
        // Notifications feature - can be implemented later
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMySwimmersBanner() {
    return InkWell(
      onTap: () => _navigateTo(const MySwimmersScreen()),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'MY SWIMMERS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '>',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.people_outline,
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    final actions = [
      _ActionItem(
        title: 'Add Program',
        icon: Icons.add_circle_outline,
        onTap: () => _navigateTo(const AddProgramScreen()),
      ),
      _ActionItem(
        title: 'My Programs',
        icon: Icons.assignment_outlined,
        onTap: () => _navigateTo(const MyProgramsScreen()),
      ),
      _ActionItem(
        title: 'Groups & Schedule',
        icon: Icons.calendar_today_outlined,
        onTap: () => _navigateTo(const ScheduleScreen()),
      ),
      _ActionItem(
        title: 'Add Branch',
        icon: Icons.location_on_outlined,
        onTap: () => _navigateTo(const AddBranchScreen()),
      ),
      _ActionItem(
        title: 'My Branches',
        icon: Icons.business_outlined,
        onTap: () => _navigateTo(const BranchesScreen()),
      ),
      _ActionItem(
        title: 'Coaches',
        icon: Icons.person_outline,
        onTap: () => _navigateTo(const CoachesScreen()),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: action.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action.icon,
                  color: const Color(0xFF2563EB),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    action.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildManagementTools() {
    final tools = [
      _ToolItem(
        title: 'Create Event',
        description: 'Set up a new swim meet or clinic.',
        color: const Color(0xFFFEE2E2),
        textColor: const Color(0xFFB91C1C),
        onTap: () {
          // Can be implemented later
        },
      ),
      _ToolItem(
        title: 'Create Offer',
        description: 'Post a discount code or package deal.',
        color: const Color(0xFFFEF3C7),
        textColor: const Color(0xFFA16207),
        onTap: () {
          // Can be implemented later
        },
      ),
      _ToolItem(
        title: 'Advertise',
        description: 'Promote your brand to our users.',
        color: const Color(0xFFDCFCE7),
        textColor: const Color(0xFF15803D),
        onTap: () {
          // Can be implemented later
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Management Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return Padding(
                padding: EdgeInsets.only(right: index < tools.length - 1 ? 16 : 0),
                child: InkWell(
                  onTap: tool.onTap,
                  child: Container(
                    width: 256,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: tool.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tool.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: tool.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tool.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF374151),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _ActionItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _ActionItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class _ToolItem {
  final String title;
  final String description;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  _ToolItem({
    required this.title,
    required this.description,
    required this.color,
    required this.textColor,
    required this.onTap,
  });
}
