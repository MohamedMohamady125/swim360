import 'package:flutter/material.dart';

class RoleData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  RoleData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  late List<Animation<Offset>> _slideAnimations;

  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  String _selectedRole = 'swimmer';
  bool _isEditingName = false;
  bool _showNameWarning = false;
  String _lastNameChangeDate = 'Never';
  String _profileImageUrl = 'https://placehold.co/200x200/24a1f1/white?text=User';

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();



  final List<RoleData> _roles = [
    RoleData(id: 'swimmer', name: 'Swimmer', icon: Icons.pool, color: const Color(0xFF3B82F6)),
    RoleData(id: 'parent', name: 'Parent', icon: Icons.family_restroom, color: const Color(0xFF10B981)),
    RoleData(id: 'shop', name: 'Shop', icon: Icons.store, color: const Color(0xFFF59E0B)),
    RoleData(id: 'academy', name: 'Academy', icon: Icons.school, color: const Color(0xFFEF4444)),
    RoleData(id: 'coach', name: 'Coach', icon: Icons.sports, color: const Color(0xFF8B5CF6)),
    RoleData(id: 'online-coach', name: 'Online Coach', icon: Icons.video_call, color: const Color(0xFF06B6D4)),
    RoleData(id: 'clinic', name: 'Clinic', icon: Icons.local_hospital, color: const Color(0xFFF97316)),
    RoleData(id: 'event-organizer', name: 'Event Organizer', icon: Icons.event, color: const Color(0xFF84CC16)),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _setupAnimations();
    _loadSavedData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _animations = List.generate(8, (index) {
      double start = (index * 0.1).clamp(0.0, 1.0);
      double end = (start + 0.4).clamp(start, 1.0);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            start,
            end,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _slideAnimations = List.generate(8, (index) {
      double start = (index * 0.1).clamp(0.0, 1.0);
      double end = (start + 0.4).clamp(start, 1.0);
      
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            start,
            end,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _animationController.forward();
  }

  void _loadSavedData() {
    // In a real app, you'd load this from SharedPreferences or a database
    // For now, we'll simulate the data
  }



  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF24A1F1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildAnimatedItem(
                    0,
                    Row(
                      children: [
                        // Profile Photo
                        _buildProfilePhoto(),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ${_name.split(' ').first}!',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Ready to swim?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Name Field
                  _buildAnimatedItem(1, _buildNameField()),
                  const SizedBox(height: 20),
                  
                  // Email Field
                  _buildAnimatedItem(2, _buildEmailField()),
                  const SizedBox(height: 20),
                  
                  // Role Section
                  _buildAnimatedItem(3, _buildRoleSection()),
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  _buildAnimatedItem(4, _buildActionButtons()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    if (index >= _animations.length) return child;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return FadeTransition(
          opacity: _animations[index],
          child: SlideTransition(
            position: _slideAnimations[index],
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildProfilePhoto() {
    return GestureDetector(
      onTap: _changeProfilePhoto,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipOval(
              child: Image.network(
                _profileImageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 96,
                    height: 96,
                    color: const Color(0xFF24A1F1),
                    child: const Center(
                      child: Text(
                        'User',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isEditingName ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          child: TextFormField(
            controller: _nameController,
            readOnly: !_isEditingName,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: _toggleNameEdit,
                icon: Icon(
                  _isEditingName ? Icons.check : Icons.edit,
                  color: _isEditingName ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
                ),
              ),
            ),
            onFieldSubmitted: (_) => _saveNameChange(),
          ),
        ),
        if (_showNameWarning) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              border: Border.all(color: const Color(0xFFD97706)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name Change Restriction',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can only change your name once every 14 days. Last changed: $_lastNameChangeDate',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFA16207),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _email,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Role',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            items: _roles.map((role) {
              return DropdownMenuItem(
                value: role.id,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: role.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(role.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedRole = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF24A1F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'View Activity',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  void _changeProfilePhoto() {
    // Simulate changing profile photo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile photo change functionality')),
    );
  }

  void _toggleNameEdit() {
    if (_isEditingName) {
      _saveNameChange();
    } else {
      setState(() {
        _isEditingName = true;
        _showNameWarning = true;
      });
    }
  }

  void _saveNameChange() {
    setState(() {
      _name = _nameController.text;
      _isEditingName = false;
      _showNameWarning = false;
      _lastNameChangeDate = 'Today';
    });
  }

  void _logout() {
    // Implement logout functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout functionality')),
    );
  }
}


