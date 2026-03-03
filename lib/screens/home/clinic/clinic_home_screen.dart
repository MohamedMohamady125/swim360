import 'package:flutter/material.dart';

class ClinicHomeScreen extends StatelessWidget {
  const ClinicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CLINIC DASHBOARD', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Text('Manage your services and bookings', style: TextStyle(fontSize: 14, color: const Color(0xFF6B7280))),
              const SizedBox(height: 24),
              _buildActionCard('My Services', Icons.medical_services_outlined, const Color(0xFF3B82F6)),
              const SizedBox(height: 16),
              _buildActionCard('Bookings', Icons.calendar_today_outlined, const Color(0xFF10B981)),
              const SizedBox(height: 16),
              _buildActionCard('Manual Booking', Icons.add_circle_outline, const Color(0xFFF59E0B)),
              const SizedBox(height: 16),
              _buildActionCard('My Branches', Icons.business_outlined, const Color(0xFF8B5CF6)),
              const SizedBox(height: 16),
              _buildActionCard('Add Branch', Icons.add_location_alt_outlined, const Color(0xFFEC4899)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
