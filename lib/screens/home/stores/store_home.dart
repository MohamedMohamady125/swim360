import 'package:flutter/material.dart';

class StoreHomeScreen extends StatelessWidget {
  const StoreHomeScreen({super.key});

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
              const Text('STORE DASHBOARD', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              const Text('Manage your products and sales', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
              const SizedBox(height: 24),

              // Notifications Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NOTIFICATIONS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                    Icon(Icons.notifications, color: Colors.white, size: 24),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Primary Action Banner - MY ORDERS
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MY ORDERS >', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                    Icon(Icons.shopping_bag, color: Colors.white, size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Core Action Cards (2x2 Grid)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildActionCard('My Branches', Icons.business_outlined, const Color(0xFF3B82F6)),
                  _buildActionCard('Add Branch', Icons.add, const Color(0xFF3B82F6)),
                  _buildActionCard('My Products', Icons.inventory_2_outlined, const Color(0xFF3B82F6)),
                  _buildActionCard('Add Products', Icons.add_circle_outline, const Color(0xFF3B82F6)),
                ],
              ),
              const SizedBox(height: 24),

              // Marketing Tools Section
              const Text('MARKETING TOOLS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPosterCard('Create Event', 'Set up a new swim meet or clinic.', const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
                    const SizedBox(width: 12),
                    _buildPosterCard('Create Offer', 'Post a discount code or package deal.', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                    const SizedBox(width: 12),
                    _buildPosterCard('Advertise', 'Promote your brand to our users.', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildPosterCard(String title, String description, Color bgColor, Color textColor) {
    return Container(
      width: 256,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}
