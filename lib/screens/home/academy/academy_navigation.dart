import 'package:flutter/material.dart';
import 'package:swim360/screens/home/academy/academy_home_screen.dart';
import 'package:swim360/screens/home/academy/my_programs_screen.dart';
import 'package:swim360/screens/home/academy/branches_screen.dart';
import 'package:swim360/screens/profile/profile_screen.dart';

class AcademyNavigation extends StatefulWidget {
  const AcademyNavigation({super.key});

  @override
  State<AcademyNavigation> createState() => _AcademyNavigationState();
}

class _AcademyNavigationState extends State<AcademyNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AcademyHomeScreen(),
    const MyProgramsScreen(),
    const BranchesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFF59E0B),
          unselectedItemColor: const Color(0xFF9CA3AF),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home, size: 28),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              activeIcon: Icon(Icons.school, size: 28),
              label: 'PROGRAMS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              activeIcon: Icon(Icons.business, size: 28),
              label: 'BRANCHES',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
