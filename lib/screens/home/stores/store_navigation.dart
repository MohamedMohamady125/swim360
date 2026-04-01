import 'package:flutter/material.dart';
import 'package:swim360/screens/home/stores/store_home.dart';
import 'package:swim360/screens/home/stores/my_products.dart';
import 'package:swim360/screens/home/stores/orders.dart';
import 'package:swim360/screens/profile/profile_screen.dart';

class StoreNavigation extends StatefulWidget {
  const StoreNavigation({super.key});

  @override
  State<StoreNavigation> createState() => _StoreNavigationState();
}

class _StoreNavigationState extends State<StoreNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const StoreHomeScreen(),
    const MyProductsScreen(),
    const OrdersScreen(),
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
          selectedItemColor: const Color(0xFF8B5CF6),
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
              icon: Icon(Icons.inventory),
              activeIcon: Icon(Icons.inventory, size: 28),
              label: 'PRODUCTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              activeIcon: Icon(Icons.shopping_bag, size: 28),
              label: 'ORDERS',
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
