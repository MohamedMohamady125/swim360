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


//updated code :
import React, { useState, useEffect, useRef, useMemo } from 'react';
import { 
  User, Mail, Shield, Settings, LogOut, ChevronRight, 
  Camera, CheckCircle, AlertCircle, ChevronLeft, 
  Activity, Bell, CreditCard, HelpCircle, Briefcase, 
  GraduationCap, Hospital, Store, Video, Users, Trophy,
  UserCircle2, LifeBuoy, Smartphone, Calendar as CalendarIcon,
  ChevronDown, X
} from 'lucide-react';

// --- MOCK DATA: ROLES ---
const ROLES = [
  { id: 'swimmer', name: 'Swimmer', icon: Users, color: '#2563eb', desc: 'Manage your training' },
  { id: 'parent', name: 'Parent', icon: Shield, color: '#10b981', desc: 'Oversee swimmer progress' },
  { id: 'coach', name: 'Coach', icon: Trophy, color: '#7c3aed', desc: 'Train and mentor' },
  { id: 'online-coach', name: 'Online Coach', icon: Video, color: '#06b6d4', desc: 'Remote digital programs' },
  { id: 'clinic', name: 'Clinic', icon: Hospital, color: '#f97316', desc: 'Recovery & medical' },
  { id: 'academy', name: 'Academy', icon: GraduationCap, color: '#2563eb', desc: 'Structured swim levels' },
  { id: 'shop', name: 'Shop', icon: Store, color: '#f59e0b', desc: 'Commerce & gear' },
  { id: 'organizer', name: 'Event Organizer', icon: Briefcase, color: '#e11d48', desc: 'Gala & camp management' },
];

export default function App() {
  const [isEditingName, setIsEditingName] = useState(false);
  const [isEditingPhone, setIsEditingPhone] = useState(false);
  const [isRoleLocked, setIsRoleLocked] = useState(false);
  
  const [userData, setUserData] = useState({
    name: 'Yehia Mansour',
    email: 'yehia.mansour@swim360.com',
    dob: 'May 20, 1995',
    phone: '+20 100 123 4567',
    roleId: null, // Initially not selected
    avatar: 'https://placehold.co/200x200/2563eb/white?text=Y',
    lastNameChange: '2025-10-15'
  });

  const [tempName, setTempName] = useState(userData.name);
  const [tempPhone, setTempPhone] = useState(userData.phone);
  const [showRolePicker, setShowRolePicker] = useState(false);
  
  // Confirmation states
  const [pendingRole, setPendingRole] = useState(null);
  const [showConfirmModal, setShowConfirmModal] = useState(false);

  // --- LOGIC ---

  const handleSaveName = () => {
    if (tempName.trim().split(' ').length < 2) {
      showSnackbar("Please enter at least first and last name.", true);
      return;
    }
    setUserData({ ...userData, name: tempName });
    setIsEditingName(false);
    showSnackbar("Name updated successfully!");
  };

  const handleSavePhone = () => {
    setUserData({ ...userData, phone: tempPhone });
    setIsEditingPhone(false);
    showSnackbar("Phone number updated!");
  };

  const initiateRoleChange = (role) => {
    if (isRoleLocked) {
      showSnackbar("Account mode is locked and cannot be changed.", true);
      return;
    }
    setPendingRole(role);
    setShowConfirmModal(true);
  };

  const confirmRoleChange = () => {
    setUserData({ ...userData, roleId: pendingRole.id });
    setIsRoleLocked(true);
    setShowConfirmModal(false);
    setShowRolePicker(false);
    showSnackbar(`Account mode locked to ${pendingRole.name}.`);
  };

  const showSnackbar = (msg, isError = false) => {
    const sn = document.createElement('div');
    sn.className = `fixed bottom-10 left-1/2 -translate-x-1/2 ${isError ? 'bg-red-500' : 'bg-gray-900'} text-white px-8 py-4 rounded-[24px] text-sm font-black shadow-2xl z-[100] animate-bounce text-center min-w-[280px]`;
    sn.textContent = msg;
    document.body.appendChild(sn);
    setTimeout(() => sn.remove(), 2500);
  };

  const getRole = (id) => ROLES.find(r => r.id === id);

  // Determine if DOB should be shown based on roleId
  const shouldShowDOB = useMemo(() => {
    return ['swimmer', 'online-coach', 'organizer'].includes(userData.roleId);
  }, [userData.roleId]);

  return (
    <div className="max-w-md mx-auto min-h-screen bg-white font-sans text-gray-900 overflow-x-hidden">
      
      {/* Header Navigation */}
      <header className="px-6 pt-12 pb-6 flex items-center justify-between sticky top-0 bg-white/90 backdrop-blur-xl z-30">
        <div className="flex items-center space-x-4">
          <button onClick={() => window.history.back()} className="p-2.5 bg-gray-50 rounded-2xl text-gray-600 border border-gray-100 active:scale-90 transition-transform">
            <ChevronLeft className="w-6 h-6" />
          </button>
          <h1 className="text-2xl font-black tracking-tight">Profile</h1>
        </div>
        <button className="p-3 bg-amber-400 rounded-2xl text-white shadow-lg shadow-amber-100 active:scale-95 transition-all">
          <Bell className="w-6 h-6" />
        </button>
      </header>

      <main className="px-6 pb-20 space-y-8 animate-in">

        {/* Profile Hero */}
        <section className="flex flex-col items-center pt-4">
          <div className="relative group">
            <div className="w-32 h-32 rounded-[40px] overflow-hidden border-4 border-white shadow-2xl shadow-blue-100 rotate-3 group-hover:rotate-0 transition-transform duration-500">
              <img src={userData.avatar} alt="Profile" className="w-full h-full object-cover" />
            </div>
            <button className="absolute -bottom-2 -right-2 p-3 bg-blue-600 text-white rounded-2xl shadow-xl border-4 border-white active:scale-90 transition-transform">
              <Camera className="w-5 h-5" />
            </button>
          </div>
          <div className="text-center mt-6">
            <h2 className="text-3xl font-black tracking-tight leading-none">{userData.name}</h2>
            <div className="mt-3 inline-flex items-center px-4 py-1.5 bg-blue-50 text-blue-600 rounded-full text-[10px] font-black uppercase tracking-widest border border-blue-100">
              <span className={`w-2 h-2 rounded-full mr-2 ${userData.roleId ? 'bg-blue-600 animate-pulse' : 'bg-gray-300'}`}></span>
              {userData.roleId ? getRole(userData.roleId).name : 'No Mode Selected'}
            </div>
          </div>
        </section>

        {/* Primary Information Fields */}
        <section className="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm space-y-6">
          
          {/* Full Name */}
          <div>
            <label className="block text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 ml-1">Full Name</label>
            <div className="relative flex items-center">
              <div className={`flex-grow flex items-center p-4 rounded-2xl transition-all border ${isEditingName ? 'border-blue-600 bg-white ring-4 ring-blue-50' : 'bg-gray-50 border-transparent'}`}>
                <input 
                  type="text" 
                  value={tempName}
                  onChange={(e) => setTempName(e.target.value)}
                  readOnly={!isEditingName}
                  className="bg-transparent border-none outline-none font-bold text-gray-800 w-full text-sm"
                />
              </div>
              <button 
                onClick={() => isEditingName ? handleSaveName() : setIsEditingName(true)}
                className={`ml-3 p-4 rounded-2xl transition-all shadow-md active:scale-90 ${isEditingName ? 'bg-green-500 text-white shadow-green-100' : 'bg-white text-gray-400'}`}
              >
                {isEditingName ? <CheckCircle className="w-6 h-6" /> : <Settings className="w-6 h-6" />}
              </button>
            </div>
          </div>

          {/* Email (Read Only) */}
          <div>
            <label className="block text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 ml-1">Email Address</label>
            <div className="flex items-center p-4 bg-gray-50/50 rounded-2xl border border-transparent">
              <Mail className="w-5 h-5 mr-3 text-gray-300" />
              <span className="font-bold text-gray-400 text-sm">{userData.email}</span>
            </div>
          </div>

          {/* Phone Number */}
          <div>
            <label className="block text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 ml-1">Phone Number</label>
            <div className="relative flex items-center">
              <div className={`flex-grow flex items-center p-4 rounded-2xl transition-all border ${isEditingPhone ? 'border-blue-600 bg-white ring-4 ring-blue-50' : 'bg-gray-50 border-transparent'}`}>
                <Smartphone className={`w-5 h-5 mr-3 ${isEditingPhone ? 'text-blue-600' : 'text-gray-300'}`} />
                <input 
                  type="tel" 
                  value={tempPhone}
                  onChange={(e) => setTempPhone(e.target.value)}
                  readOnly={!isEditingPhone}
                  className="bg-transparent border-none outline-none font-bold text-gray-800 w-full text-sm"
                />
              </div>
              <button 
                onClick={() => isEditingPhone ? handleSavePhone() : setIsEditingPhone(true)}
                className={`ml-3 p-4 rounded-2xl transition-all shadow-md active:scale-90 ${isEditingPhone ? 'bg-purple-500 text-white shadow-purple-100' : 'bg-white text-gray-400'}`}
              >
                {isEditingPhone ? <CheckCircle className="w-5 h-5" /> : <Settings className="w-5 h-5" />}
              </button>
            </div>
          </div>
        </section>

        {/* Role Selector Section */}
        <section className="relative space-y-4">
          <div>
            <label className="block text-[10px] font-black text-gray-400 uppercase tracking-widest mb-3 ml-1">Account Mode</label>
            <button 
                onClick={() => isRoleLocked ? showSnackbar("Account mode is locked and cannot be changed.", true) : setShowRolePicker(!showRolePicker)}
                className={`w-full bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm flex items-center justify-between group transition-all ${isRoleLocked ? 'cursor-not-allowed opacity-80' : 'active:bg-gray-50'}`}
            >
                <div className="flex items-center">
                {userData.roleId ? (
                    <>
                    <div className="w-12 h-12 rounded-2xl flex items-center justify-center mr-4 shadow-inner" style={{ backgroundColor: `${getRole(userData.roleId).color}15`, color: getRole(userData.roleId).color }}>
                        {React.createElement(getRole(userData.roleId).icon, { className: "w-6 h-6" })}
                    </div>
                    <div className="text-left">
                        <p className="font-black text-gray-900 leading-none">{getRole(userData.roleId).name}</p>
                        <p className="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-1.5 flex items-center">
                        <ShieldCheck className="w-3 h-3 mr-1" /> Profile Locked
                        </p>
                    </div>
                    </>
                ) : (
                    <>
                    <div className="w-12 h-12 rounded-2xl bg-gray-50 flex items-center justify-center mr-4">
                        <UserCircle2 className="w-6 h-6 text-gray-300" />
                    </div>
                    <div className="text-left">
                        <p className="font-black text-gray-400 leading-none">Not Selected</p>
                        <p className="text-[10px] font-bold text-gray-300 uppercase tracking-widest mt-1.5">Choose your path</p>
                    </div>
                    </>
                )}
                </div>
                {!isRoleLocked && (
                <ChevronDown className={`w-6 h-6 text-gray-300 transition-transform duration-300 ${showRolePicker ? 'rotate-180' : ''}`} />
                )}
            </button>
          </div>

          {/* Conditional Date of Birth Field - Under Account Mode */}
          {shouldShowDOB && (
            <div className="animate-in">
              <label className="block text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 ml-1">Date of Birth</label>
              <div className="flex items-center p-4 bg-gray-50/80 rounded-[24px] border border-gray-100">
                <CalendarIcon className="w-5 h-5 mr-3 text-blue-600" />
                <span className="font-bold text-gray-800 text-sm">{userData.dob}</span>
              </div>
            </div>
          )}

          {showRolePicker && !isRoleLocked && (
            <div className="absolute top-full left-0 right-0 mt-3 bg-white rounded-[32px] border border-gray-100 shadow-2xl z-50 p-4 space-y-2 animate-in overflow-y-auto max-h-[400px]">
               <div className="p-3 bg-amber-50 rounded-2xl flex items-start mb-2 border border-amber-100">
                  <AlertCircle className="w-4 h-4 text-amber-600 mr-2 mt-0.5 flex-shrink-0" />
                  <p className="text-[10px] font-bold text-amber-700 uppercase leading-relaxed">Warning: You can only select an account mode once. It cannot be changed later.</p>
               </div>
              {ROLES.map((role) => (
                <button 
                  key={role.id}
                  onClick={() => initiateRoleChange(role)}
                  className="w-full p-4 rounded-2xl flex items-center justify-between transition-all bg-gray-50 hover:bg-gray-100"
                >
                  <div className="flex items-center">
                    <div className={`w-10 h-10 rounded-xl flex items-center justify-center mr-3 bg-white border border-gray-100`} style={{ color: role.color }}>
                      {React.createElement(role.icon, { className: "w-5 h-5" })}
                    </div>
                    <div className="text-left">
                      <p className="text-sm font-black tracking-tight">{role.name}</p>
                      <p className={`text-[9px] font-bold uppercase tracking-widest opacity-70 text-gray-400`}>{role.desc}</p>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          )}
        </section>

        {/* Refined Rectangular Action Buttons */}
        <section className="space-y-4 pt-4 pb-12">
          
          {/* Switch User Card */}
          <div className="relative group action-card w-full rounded-[28px] p-6 text-white cursor-pointer overflow-hidden flex items-center" 
               style={{ background: 'linear-gradient(135deg, #a855f7 0%, #7c3aed 100%)' }}
               onClick={() => showSnackbar("Opening User Switcher...")}>
            <div className="absolute -right-6 w-32 h-32 bg-white/10 rounded-full group-hover:scale-110 transition-transform duration-700"></div>
            <div className="w-14 h-14 bg-white/20 backdrop-blur rounded-[20px] flex items-center justify-center relative z-10 mr-5">
              <UserCircle2 className="w-8 h-8" />
            </div>
            <div className="relative z-10 flex-grow">
              <h3 className="font-black text-xl leading-none">Switch User</h3>
              <p className="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">Access Family Accounts</p>
            </div>
            <ChevronRight className="w-6 h-6 text-white/40 group-hover:translate-x-1 transition-transform" />
          </div>

          {/* Help & Support Card - LIGHT GREEN THEME */}
          <div className="relative group action-card w-full rounded-[28px] p-6 text-white cursor-pointer overflow-hidden flex items-center" 
               style={{ background: 'linear-gradient(135deg, #4ade80 0%, #10b981 100%)' }}
               onClick={() => showSnackbar("Connecting to support...")}>
            <div className="absolute -bottom-10 -right-5 w-40 h-40 bg-white/10 rounded-full"></div>
            <div className="w-14 h-14 bg-white/20 backdrop-blur rounded-[20px] flex items-center justify-center relative z-10 mr-5">
              <LifeBuoy className="w-8 h-8" />
            </div>
            <div className="relative z-10 flex-grow">
              <h3 className="font-black text-xl leading-none">Help & Support</h3>
              <p className="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">24/7 Concierge</p>
            </div>
            <ChevronRight className="w-6 h-6 text-white/40 group-hover:translate-x-1 transition-transform" />
          </div>

          {/* Log Out Card */}
          <div className="relative group action-card w-full rounded-[28px] p-6 text-white cursor-pointer overflow-hidden flex items-center" 
               style={{ background: 'linear-gradient(135deg, #f43f5e 0%, #e11d48 100%)' }}
               onClick={() => showSnackbar("Logging out safely...")}>
            <div className="absolute -top-10 -left-10 w-32 h-32 bg-white/10 rounded-full opacity-40"></div>
            <div className="w-14 h-14 bg-white/20 backdrop-blur rounded-[20px] flex items-center justify-center relative z-10 mr-5">
              <LogOut className="w-8 h-8" />
            </div>
            <div className="relative z-10 flex-grow">
              <h3 className="font-black text-xl leading-none">Log Out</h3>
              <p className="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">Close Secure Session</p>
            </div>
            <ChevronRight className="w-6 h-6 text-white/40 group-hover:translate-x-1 transition-transform" />
          </div>

        </section>

      </main>

      {/* CONFIRMATION MODAL */}
      {showConfirmModal && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-6 bg-slate-900/60 backdrop-blur-sm animate-in">
          <div className="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl space-y-6">
            <div className="w-20 h-20 bg-amber-50 text-amber-500 rounded-3xl flex items-center justify-center mx-auto">
              <AlertCircle className="w-12 h-12" />
            </div>
            <div className="text-center space-y-2">
              <h3 className="text-2xl font-black text-gray-900 tracking-tight">Confirm Mode</h3>
              <p className="text-sm text-gray-500 font-medium">Are you sure you want to set your account to <span className="text-blue-600 font-black">"{pendingRole?.name}"</span>? This action is permanent.</p>
            </div>
            <div className="flex flex-col space-y-3 pt-2">
              <button 
                onClick={confirmRoleChange}
                className="w-full py-4 bg-blue-600 text-white rounded-[20px] font-black shadow-xl shadow-blue-100 active:scale-95 transition"
              >
                Yes, Lock Mode
              </button>
              <button 
                onClick={() => setShowConfirmModal(false)}
                className="w-full py-4 bg-gray-50 text-gray-400 rounded-[20px] font-bold active:scale-95 transition"
              >
                No, Go Back
              </button>
            </div>
          </div>
        </div>
      )}

      <style>{`
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .action-card { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .action-card:active { transform: scale(0.96); }
      `}</style>
    </div>
  );
}

// --- HELPER COMPONENT ---
function ChevronDown({ className }) {
  return (
    <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M19 9l-7 7-7-7" />
    </svg>
  );
}