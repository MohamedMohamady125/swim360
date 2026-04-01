import 'package:flutter/material.dart';
import 'package:swim360/screens/home/clinic/clinic_home_screen.dart';
import 'package:swim360/screens/home/clinic/bookings.dart';
import 'package:swim360/screens/home/clinic/my_services.dart';
import 'package:swim360/screens/profile/profile_screen.dart';

class ClinicNavigation extends StatefulWidget {
  const ClinicNavigation({super.key});

  @override
  State<ClinicNavigation> createState() => _ClinicNavigationState();
}

class _ClinicNavigationState extends State<ClinicNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ClinicHomeScreen(),
    const BookingsScreen(),
    const MyServicesScreen(),
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
          selectedItemColor: const Color(0xFFEF4444),
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
              icon: Icon(Icons.calendar_today),
              activeIcon: Icon(Icons.calendar_today, size: 28),
              label: 'BOOKINGS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              activeIcon: Icon(Icons.medical_services, size: 28),
              label: 'SERVICES',
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
