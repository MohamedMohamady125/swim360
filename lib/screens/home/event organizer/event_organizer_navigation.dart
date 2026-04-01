import 'package:flutter/material.dart';
import 'package:swim360/screens/home/event organizer/event_organizer_home.dart';
import 'package:swim360/screens/home/event organizer/my_events.dart';
import 'package:swim360/screens/home/event organizer/my_attendees.dart';
import 'package:swim360/screens/profile/profile_screen.dart';

class EventOrganizerNavigation extends StatefulWidget {
  const EventOrganizerNavigation({super.key});

  @override
  State<EventOrganizerNavigation> createState() => _EventOrganizerNavigationState();
}

class _EventOrganizerNavigationState extends State<EventOrganizerNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EventOrganizerHomeScreen(),
    const MyEventsScreen(),
    const MyAttendeesScreen(),
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
          selectedItemColor: const Color(0xFF06B6D4),
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
              icon: Icon(Icons.event),
              activeIcon: Icon(Icons.event, size: 28),
              label: 'EVENTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              activeIcon: Icon(Icons.group, size: 28),
              label: 'ATTENDEES',
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
