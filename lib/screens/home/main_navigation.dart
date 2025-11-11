import 'package:flutter/material.dart';
import '../events/events_screen.dart';
import '../profile/profile_screen.dart';
import '../marketplace/used_screen.dart';
import '../marketplace/stores_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  String _currentLang = 'en';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _toggleLanguage() {
    setState(() {
      _currentLang = _currentLang == 'en' ? 'ar' : 'en';
    });
  }

  String getText(String key) {
    final translations = {
      'en': {
        'home_title': 'Home',
        'events_title': 'Events',
        'marketplace_title': 'Marketplace',
        'profile_title': 'Profile',
        'home_greeting': 'Welcome to Swim 360! This is your main dashboard. Check the latest events and marketplace deals.',
        'stats_title': 'Quick Stats',
        'stats_content': 'Total Swims: 45 | Average Speed: 1.5 m/s',
        'toggle_language': 'Toggle Language (العربية)',
        'events_info': 'Discover and register for upcoming swimming competitions and local meetups!',
        'event1': 'Regional Championship - Aug 10th',
        'event2': 'Open Water Fun Swim - Sep 5th',
        'event3': 'Masters Training Session - Every Tuesday',
        'marketplace_info': 'Buy and sell swimming gear, equipment, and training services.',
        'item1': 'Racing Goggles',
        'item2': 'Used Fins',
        'item3': 'Stopwatches',
        'item4': 'Sunscreen Bulk',
        'profile_info': 'Manage your account details and view your swimming history.',
        'profile_name': 'Name: John Doe',
        'profile_level': 'Level: Advanced',
        'profile_team': 'Team: Blue Sharks',
        'nav_home': 'Home',
        'nav_events': 'Events',
        'nav_marketplace': 'Marketplace',
        'nav_profile': 'Profile',
      },
      'ar': {
        'home_title': 'الرئيسية',
        'events_title': 'الفعاليات',
        'marketplace_title': 'السوق',
        'profile_title': 'الملف الشخصي',
        'home_greeting': 'مرحباً بك في Swim 360! هذه هي لوحة القيادة الرئيسية الخاصة بك. اطلع على أحدث الفعاليات وعروض السوق.',
        'stats_title': 'إحصائيات سريعة',
        'stats_content': 'إجمالي السباحات: ٤٥ | متوسط السرعة: ١.٥ متر/ثانية',
        'toggle_language': 'تبديل اللغة (English)',
        'events_info': 'اكتشف وسجل في مسابقات السباحة القادمة واللقاءات المحلية!',
        'event1': 'بطولة إقليمية - ١٠ أغسطس',
        'event2': 'سباحة ممتعة في المياه المفتوحة - ٥ سبتمبر',
        'event3': 'جلسة تدريب للمحترفين - كل ثلاثاء',
        'marketplace_info': 'قم بشراء وبيع معدات السباحة والمعدات والخدمات التدريبية.',
        'item1': 'نظارات سباحة للسباق',
        'item2': 'زعانف مستعملة',
        'item3': 'ساعات توقيت',
        'item4': 'كريم واقي من الشمس بالجملة',
        'profile_info': 'إدارة تفاصيل حسابك وعرض سجل السباحة الخاص بك.',
        'profile_name': 'الاسم: جون دو',
        'profile_level': 'المستوى: متقدم',
        'profile_team': 'الفريق: أسماك القرش الزرقاء',
        'nav_home': 'الرئيسية',
        'nav_events': 'الفعاليات',
        'nav_marketplace': 'السوق',
        'nav_profile': 'الملف الشخصي',
      },
    };
    
    return translations[_currentLang]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {

    final bool isRTL = _currentLang == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: SafeArea(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildCurrentView(),
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeView();
      case 1:
        return const EventsScreen();
      case 2:
        return _buildMarketplaceView();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getText('home_title'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              getText('home_greeting'),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getText('stats_title'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    getText('stats_content'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleLanguage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  getText('toggle_language'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketplaceView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getText('marketplace_title'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Buy and sell swimming gear and equipment.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
              children: [
                _buildNavigableMarketplaceItem(
                  const Icon(Icons.storefront_outlined, size: 64, color: Color(0xFF2563EB)),
                  'Stores',
                  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StoresScreen()),
                  );
                }),
                _buildNavigableMarketplaceItem(
                  const Icon(Icons.recycling_outlined, size: 64, color: Color(0xFF0EA5E9)),
                  'Used Items',
                  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsedScreen()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildNavigableMarketplaceItem(Widget icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildBottomNavigationBar() {
    return Container(
      height: 64,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, getText('nav_home')),
          _buildNavItem(1, Icons.event, getText('nav_events')),
          _buildNavItem(2, Icons.shopping_cart, getText('nav_marketplace')),
          _buildNavItem(3, Icons.person, getText('nav_profile')),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF6B7280),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


