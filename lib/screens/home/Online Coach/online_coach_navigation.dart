import 'package:flutter/material.dart';
import 'package:swim360/screens/home/Online Coach/online_coach_home.dart';
import 'package:swim360/screens/home/Online Coach/my_programs.dart';
import 'package:swim360/screens/home/Online Coach/my_clients.dart';
import 'package:swim360/screens/profile/profile_screen.dart';

class OnlineCoachNavigation extends StatefulWidget {
  const OnlineCoachNavigation({super.key});

  @override
  State<OnlineCoachNavigation> createState() => _OnlineCoachNavigationState();
}

class _OnlineCoachNavigationState extends State<OnlineCoachNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const OnlineCoachHomeScreen(),
    const MyProgramsScreen(),
    const MyClientsScreen(),
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
          selectedItemColor: const Color(0xFF0891B2),
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
              icon: Icon(Icons.fitness_center),
              activeIcon: Icon(Icons.fitness_center, size: 28),
              label: 'PROGRAMS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              activeIcon: Icon(Icons.people, size: 28),
              label: 'CLIENTS',
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
