import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with TickerProviderStateMixin {
  String currentLang = 'en';
  String searchQuery = '';
  String selectedType = 'all';
  String selectedAge = 'all';
  DateTime? startDate;
  DateTime? endDate;
  String sortBy = 'date-asc';
  bool showFilterModal = false;

  late AnimationController _modalController;
  late Animation<double> _modalAnimation;

  final List<EventData> events = [
    EventData(
      id: 'event1',
      title: {'en': 'Regional Championship', 'ar': 'بطولة إقليمية'},
      description: {
        'en': 'This is the premier swimming event of the season, featuring top athletes from five regions competing for the coveted gold medal. All ages and skill levels are welcome to watch and participate in support activities. Sign up now!',
        'ar': 'هذا هو الحدث الأبرز للسباحة هذا الموسم، يضم نخبة من الرياضيين من خمس مناطق يتنافسون على الميدالية الذهبية المرموقة. نرحب بجميع الأعمار ومستويات المهارة للمشاهدة والمشاركة في الأنشطة الداعمة. سجل الآن!'
      },
      date: DateTime(2025, 11, 10),
      duration: {'en': '9:00 AM | 3 hrs', 'ar': '9:00 ص | 3 ساعات'},
      location: {'en': 'Central Pool (NYC)', 'ar': 'المسبح المركزي (NYC)'},
      type: 'championship',
      ageGroup: '15+',
      price: 45,
      seatsLeft: 25,
      imageColor: const Color(0xFF1D4ED8),
      coordinates: '40.7128,-74.0060',
    ),
    EventData(
      id: 'event2',
      title: {'en': 'Open Water Fun Swim', 'ar': 'سباحة ترفيهية في المياه المفتوحة'},
      description: {
        'en': 'A social and non-competitive open water swimming event perfect for all levels. Wetsuits are encouraged. Meet at the main beach flagpole. Snacks and warm drinks provided afterwards!',
        'ar': 'فعالية سباحة اجتماعية وغير تنافسية في المياه المفتوحة مثالية لجميع المستويات. نشجع على ارتداء بدلات الغوص. التجمع عند سارية العلم الرئيسية على الشاطئ. يتم توفير الوجبات الخفيفة والمشروبات الدافئة لاحقاً!'
      },
      date: DateTime(2025, 11, 15),
      duration: {'en': '8:30 AM | 2 hours', 'ar': '8:30 ص | ساعتين'},
      location: {'en': 'Sea Coast (LA)', 'ar': 'شاطئ البحر (LA)'},
      type: 'fun-swim',
      ageGroup: 'all-ages',
      price: 0,
      seatsLeft: 10,
      imageColor: const Color(0xFFEF4444),
      coordinates: '34.0522,-118.2437',
    ),
    EventData(
      id: 'event3',
      title: {'en': 'Masters Training Session', 'ar': 'جلسة تدريب للمحترفين'},
      description: {
        'en': 'Focused training for competitive swimmers aged 25+. High-intensity intervals and technique drills led by Coach Sarah. Drop-in available for \$15. Secure your spot early!',
        'ar': 'تدريب مركز للسباحين المتنافسين الذين تتراوح أعمارهم بين 25+ فما فوق. تدريبات متكررة عالية الكثافة وتمارين تقنية بقيادة المدربة سارة. Drop-in متاح مقابل 15 دولار. احجز مكانك مبكراً!'
      },
      date: DateTime(2025, 12, 1),
      duration: {'en': '7:00 PM | 90 mins', 'ar': '7:00 م | 90 دقيقة'},
      location: {'en': 'Local Gym Pool (LON)', 'ar': 'مسبح النادي المحلي (LON)'},
      type: 'training',
      ageGroup: 'adults',
      price: 15,
      seatsLeft: 4,
      imageColor: const Color(0xFF059669),
      coordinates: '51.5074,-0.1278',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _modalController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _modalAnimation = CurvedAnimation(
      parent: _modalController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _modalController.dispose();
    super.dispose();
  }

  String getText(String key) {
    final translations = {
      'en': {
        'events_title': 'Events',
        'search_placeholder': 'Search events by title...',
        'filter': 'Filter',
        'sort_date_asc': 'Date (Soonest)',
        'sort_price_asc': 'Price (Lowest)',
        'sort_price_desc': 'Price (Highest)',
        'see_details': 'See Details',
        'go_back': 'Go Back',
        'register': 'Register',
        'registered': 'Registered!',
        'sold_out': 'Sold Out',
        'seats_left': 'Seats Left',
        'free': 'FREE',
        'filter_events': 'Filter Events',
        'event_type': 'Event Type',
        'age_group': 'Age Group',
        'date_range': 'Date Range',
        'start_date': 'Start Date',
        'end_date': 'End Date',
        'reset': 'Reset',
        'apply_filters': 'Apply Filters',
        'all_types': 'All Types',
        'championship': 'Championship',
        'fun_swim': 'Fun Swim',
        'training': 'Training Clinic',
        'all_ages': 'All Ages',
        'kids': 'Kids (10-)',
        '15+': '15+',
        'adults': 'Adults (25+)',
        'description': 'Description',
      },
      'ar': {
        'events_title': 'الفعاليات',
        'search_placeholder': 'ابحث عن الفعاليات حسب العنوان...',
        'filter': 'تصفية',
        'sort_date_asc': 'التاريخ (الأقرب)',
        'sort_price_asc': 'السعر (الأدنى)',
        'sort_price_desc': 'السعر (الأعلى)',
        'see_details': 'رؤية التفاصيل',
        'go_back': 'العودة',
        'register': 'تسجيل',
        'registered': 'تم التسجيل!',
        'sold_out': 'نفدت المقاعد',
        'seats_left': 'مقاعد متبقية',
        'free': 'مجاني',
        'filter_events': 'تصفية الفعاليات',
        'event_type': 'نوع الفعالية',
        'age_group': 'الفئة العمرية',
        'date_range': 'نطاق التاريخ',
        'start_date': 'تاريخ البداية',
        'end_date': 'تاريخ النهاية',
        'reset': 'إعادة تعيين',
        'apply_filters': 'تطبيق التصفية',
        'all_types': 'جميع الأنواع',
        'championship': 'بطولة',
        'fun_swim': 'سباحة ترفيهية',
        'training': 'عيادة تدريب',
        'all_ages': 'جميع الأعمار',
        'kids': 'أطفال (10-)',
        '15+': '15+',
        'adults': 'بالغون (25+)',
        'description': 'الوصف',
      },
    };
    
    return translations[currentLang]?[key] ?? key;
  }

  List<EventData> getFilteredAndSortedEvents() {
    List<EventData> filtered = events.where((event) {
      // Search filter
      if (searchQuery.isNotEmpty && 
          !event.title[currentLang]!.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      
      // Type filter
      if (selectedType != 'all' && event.type != selectedType) {
        return false;
      }
      
      // Age filter
      if (selectedAge != 'all' && event.ageGroup != selectedAge) {
        return false;
      }
      
      // Date range filter
      if (startDate != null && event.date.isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && event.date.isAfter(endDate!.add(const Duration(days: 1)))) {
        return false;
      }
      
      return true;
    }).toList();
    
    // Sort
    filtered.sort((a, b) {
      switch (sortBy) {
        case 'date-asc':
          return a.date.compareTo(b.date);
        case 'price-asc':
          return a.price.compareTo(b.price);
        case 'price-desc':
          return b.price.compareTo(a.price);
        default:
          return 0;
      }
    });
    
    return filtered;
  }

  // Removed: location opener moved into EventCard for direct usage

  void _showFilterModal() {
    setState(() {
      showFilterModal = true;
    });
    _modalController.forward();
  }

  void _hideFilterModal() {
    _modalController.reverse().then((_) {
      setState(() {
        showFilterModal = false;
      });
    });
  }

  void _resetFilters() {
    setState(() {
      selectedType = 'all';
      selectedAge = 'all';
      startDate = null;
      endDate = null;
      sortBy = 'date-asc';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = getFilteredAndSortedEvents();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F6),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title
                  Text(
                    getText('events_title'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E40AF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Search and controls
                  _buildSearchAndControls(),
                  const SizedBox(height: 32),
                  
                  // Events list
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: EventCard(
                            event: filteredEvents[index],
                            currentLang: currentLang,
                            getText: getText,
                            onRegister: () => _registerForEvent(filteredEvents[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter modal
            if (showFilterModal) _buildFilterModal(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndControls() {
    return Column(
      children: [
        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: getText('search_placeholder'),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Sort and filter controls
        Row(
          children: [
            // Sort dropdown
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sortBy,
                    onChanged: (value) {
                      setState(() {
                        sortBy = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: 'date-asc', child: Text(getText('sort_date_asc'))),
                      DropdownMenuItem(value: 'price-asc', child: Text(getText('sort_price_asc'))),
                      DropdownMenuItem(value: 'price-desc', child: Text(getText('sort_price_desc'))),
                    ],
                    icon: const Icon(Icons.sort, color: Color(0xFF6B7280)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Filter button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _showFilterModal,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterModal() {
    return AnimatedBuilder(
      animation: _modalAnimation,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.6 * _modalAnimation.value),
          child: Center(
            child: Transform.scale(
              scale: 0.8 + (0.2 * _modalAnimation.value),
              child: Opacity(
                opacity: _modalAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getText('filter_events'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          IconButton(
                            onPressed: _hideFilterModal,
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const Divider(),
                      
                      // Event Type
                      const SizedBox(height: 16),
                      Text(
                        getText('event_type'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildFilterChip('all', getText('all_types'), selectedType),
                          _buildFilterChip('championship', getText('championship'), selectedType),
                          _buildFilterChip('fun-swim', getText('fun_swim'), selectedType),
                          _buildFilterChip('training', getText('training'), selectedType),
                        ].map((chip) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = (chip.key as ValueKey<String>).value;
                            });
                          },
                          child: chip,
                        )).toList(),
                      ),
                      
                      // Age Group
                      const SizedBox(height: 20),
                      Text(
                        getText('age_group'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildFilterChip('all', getText('all_ages'), selectedAge),
                          _buildFilterChip('kids', getText('kids'), selectedAge),
                          _buildFilterChip('15+', getText('15+'), selectedAge),
                          _buildFilterChip('all-ages', getText('all_ages'), selectedAge),
                          _buildFilterChip('adults', getText('adults'), selectedAge),
                        ].map((chip) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAge = (chip.key as ValueKey<String>).value;
                            });
                          },
                          child: chip,
                        )).toList(),
                      ),
                      
                      // Date Range (simplified for demo)
                      const SizedBox(height: 20),
                      Text(
                        getText('date_range'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date filtering functionality can be added here',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      
                      // Action buttons
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _resetFilters();
                                _hideFilterModal();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE5E7EB),
                                foregroundColor: const Color(0xFF374151),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(getText('reset')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _hideFilterModal,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(getText('apply_filters')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String value, String label, String selectedValue) {
    final isSelected = value == selectedValue;
    return Container(
      key: ValueKey(value),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF10B981) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFFD1D5DB),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF4B5563),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  void _registerForEvent(EventData event) {
    if (event.seatsLeft > 0) {
      setState(() {
        int index = events.indexWhere((e) => e.id == event.id);
        if (index != -1) {
          events[index] = events[index].copyWith(seatsLeft: events[index].seatsLeft - 1);
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getText('registered')),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }
}

class EventData {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final DateTime date;
  final Map<String, String> duration;
  final Map<String, String> location;
  final String type;
  final String ageGroup;
  final int price;
  final int seatsLeft;
  final Color imageColor;
  final String coordinates;

  EventData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.location,
    required this.type,
    required this.ageGroup,
    required this.price,
    required this.seatsLeft,
    required this.imageColor,
    required this.coordinates,
  });

  EventData copyWith({
    String? id,
    Map<String, String>? title,
    Map<String, String>? description,
    DateTime? date,
    Map<String, String>? duration,
    Map<String, String>? location,
    String? type,
    String? ageGroup,
    int? price,
    int? seatsLeft,
    Color? imageColor,
    String? coordinates,
  }) {
    return EventData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      type: type ?? this.type,
      ageGroup: ageGroup ?? this.ageGroup,
      price: price ?? this.price,
      seatsLeft: seatsLeft ?? this.seatsLeft,
      imageColor: imageColor ?? this.imageColor,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

class EventCard extends StatefulWidget {
  final EventData event;
  final String currentLang;
  final String Function(String) getText;
  final VoidCallback onRegister;

  const EventCard({
    Key? key,
    required this.event,
    required this.currentLang,
    required this.getText,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  Future<void> _openLocation(String coordinates, String label) async {
    final parts = coordinates.split(',');
    if (parts.length != 2) return;
    final lat = parts[0].trim();
    final lng = parts[1].trim();

    // Prefer platform-specific scheme if available, else fall back to Google Maps web
    Uri? uri;
    if (Platform.isIOS) {
      // Apple Maps
      uri = Uri.parse('http://maps.apple.com/?ll=$lat,$lng&q=${Uri.encodeComponent(label)}');
    } else {
      // Android/others - Google Maps
      uri = Uri.parse('geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(label)})');
    }

    if (!await canLaunchUrl(uri)) {
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    }
  await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        if (_flipAnimation.value < 0.5) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * 3.14159),
            child: _buildFrontCard(),
          );
        } else {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((_flipAnimation.value - 1) * 3.14159),
            child: _buildBackCard(),
          );
        }
      },
    );
  }

  Widget _buildFrontCard() {
    final currency = widget.currentLang == 'ar' ? 'ر.س' : '\$';
    final priceText = widget.event.price == 0 ? widget.getText('free') : '$currency${widget.event.price}';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image header
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: widget.event.imageColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                widget.event.title[widget.currentLang] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.event.title[widget.currentLang] ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Metadata grid - natural sizing
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildMetadataItem(Icons.calendar_today, _formatDate(widget.event.date))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMetadataItem(Icons.access_time, widget.event.duration[widget.currentLang] ?? '')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _openLocation(widget.event.coordinates, widget.event.location[widget.currentLang] ?? ''),
                            child: _buildMetadataItem(Icons.location_on, widget.event.location[widget.currentLang] ?? ''),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMetadataItem(Icons.category, _getTypeText())),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildMetadataItem(Icons.people, _getAgeText())),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMetadataItem(Icons.attach_money, priceText)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildMetadataItem(Icons.event_seat, '${widget.event.seatsLeft} ${widget.getText('seats_left')}', 
                      color: const Color(0xFFDC2626)),
                  ],
                ),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _flip,
                      child: Text(
                        widget.getText('see_details'),
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: widget.event.seatsLeft > 0 ? widget.onRegister : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.event.seatsLeft > 0 
                          ? const Color(0xFF10B981) 
                          : const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                      child: Text(
                        widget.event.seatsLeft > 0 
                          ? widget.getText('register') 
                          : widget.getText('sold_out'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.getText('description'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF),
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder details section while waiting for real structured content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Additional Event Details (Coming Soon)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      )),
                  SizedBox(height: 8),
                  Text(
                    'This area will display schedule, warm-up lanes, required gear, parking info, and organizer contacts. Placeholder content for now. Tap Go Back to flip the card.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              height: 180,
              child: SingleChildScrollView(
                child: Text(
                  widget.event.description[widget.currentLang] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
              ),
            ),
            
            const Divider(),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _flip,
                  child: Text(
                    widget.getText('go_back'),
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.event.seatsLeft > 0 ? widget.onRegister : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.event.seatsLeft > 0 
                      ? const Color(0xFF10B981) 
                      : const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: Text(
                    widget.event.seatsLeft > 0 
                      ? widget.getText('register') 
                      : widget.getText('sold_out'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? const Color(0xFF1D4ED8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: color ?? const Color(0xFF4B5563),
                fontWeight: color != null ? FontWeight.bold : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = widget.currentLang == 'ar' 
      ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
      : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    if (widget.currentLang == 'ar') {
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } else {
      return '${months[date.month - 1]} ${date.day}${_getDaySuffix(date.day)} ${date.year}';
    }
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  String _getTypeText() {
    final typeMap = {
      'championship': widget.getText('championship'),
      'fun-swim': widget.getText('fun_swim'),
      'training': widget.getText('training'),
    };
    return typeMap[widget.event.type] ?? widget.event.type;
  }

  String _getAgeText() {
    final ageMap = {
      'kids': widget.getText('kids'),
      '15+': widget.getText('15+'),
      'all-ages': widget.getText('all_ages'),
      'adults': widget.getText('adults'),
    };
    return ageMap[widget.event.ageGroup] ?? widget.event.ageGroup;
  }
}
//             display: grid;
//             grid-template-columns: 1fr auto;
//             gap: 0.75rem;
//             align-items: center;
//         }
        
//         .search-container {
//             position: relative;
//             grid-column: 1 / span 2; /* Search spans both columns on mobile */
//         }
//         /* On medium screens (or wider mobile view), split search and sort */
//         @media (min-width: 400px) {
//             .top-controls {
//                 grid-template-columns: 1fr auto auto;
//             }
//             .search-container {
//                 grid-column: auto;
//             }
//         }

//         .search-input {
//             width: 100%;
//             padding: 0.75rem 1rem 0.75rem 3rem; /* Padding for icon */
//             border-radius: 9999px;
//             border: 1px solid #d1d5db;
//             outline: none;
//             transition: border-color 0.2s, box-shadow 0.2s;
//             background-color: white;
//         }
//         .search-input:focus {
//             border-color: #3b82f6;
//             box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.3);
//         }
//         .search-icon {
//             position: absolute;
//             top: 50%;
//             left: 1rem;
//             transform: translateY(-50%);
//             color: #6b7280;
//             pointer-events: none;
//         }
        
//         #filter-btn, #sort-control-container {
//             flex-shrink: 0;
//             height: 44px; /* Match height of search input */
//         }

//         /* Sort dropdown styling */
//         #sort-control-container {
//             position: relative;
//             display: inline-flex;
//             align-items: center;
//             border-radius: 9999px;
//             background-color: white;
//             border: 1px solid #d1d5db;
//             padding: 0 0.5rem;
//             transition: border-color 0.2s;
//         }
//         #sort-control-container:focus-within {
//              border-color: #3b82f6;
//         }

//         #sort-select {
//             appearance: none; /* Hide default dropdown arrow */
//             background: transparent;
//             border: none;
//             outline: none;
//             padding: 0.5rem 0.5rem 0.5rem 0.25rem;
//             font-size: 0.875rem;
//             font-weight: 500;
//             cursor: pointer;
//             color: #1f2937;
//         }

//         #filter-btn {
//             background-color: #3b82f6;
//             color: white;
//             padding: 0.75rem;
//             border-radius: 9999px;
//             display: flex;
//             align-items: center;
//             justify-content: center;
//             cursor: pointer;
//             transition: background-color 0.2s, transform 0.1s;
//             box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
//         }
//         #filter-btn:hover {
//             background-color: #2563eb;
//         }
//         #filter-btn:active {
//             transform: scale(0.98);
//         }

//         /* --- Modal Styling --- (Retained) */
//         .modal-overlay {
//             position: fixed;
//             top: 0;
//             left: 0;
//             right: 0;
//             bottom: 0;
//             background-color: rgba(0, 0, 0, 0.6);
//             display: flex;
//             justify-content: center;
//             align-items: center;
//             z-index: 50; /* Above nav bar */
//             opacity: 0;
//             visibility: hidden;
//             transition: opacity 0.3s ease;
//         }
//         .modal-overlay.active {
//             opacity: 1;
//             visibility: visible;
//         }
//         .modal-content {
//             background-color: white;
//             padding: 1.5rem;
//             border-radius: 1.5rem;
//             width: 90%;
//             max-width: 450px;
//             transform: translateY(50px);
//             transition: transform 0.3s ease;
//             box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
//         }
//         .modal-overlay.active .modal-content {
//             transform: translateY(0);
//         }
        
//         .filter-group-label {
//             font-weight: 600;
//             color: #1f2937;
//             margin-bottom: 0.5rem;
//             display: block;
//         }
        
//         .option-tag {
//             padding: 0.4rem 1rem;
//             border-radius: 9999px;
//             font-size: 0.875rem;
//             font-weight: 500;
//             cursor: pointer;
//             transition: all 0.2s;
//             border: 1px solid #d1d5db;
//             background-color: #f3f4f6;
//             color: #4b5563;
//         }
//         .option-tag.selected {
//             background-color: #10b981; 
//             color: white;
//             border-color: #10b981;
//             box-shadow: 0 2px 4px rgba(16, 185, 129, 0.3);
//         }

//         /* --- Card and Icon Styling --- */
//         .event-card-container {
//             perspective: 1000px;
//             height: 360px;
//         }
//         .event-card {
//             position: relative;
//             width: 100%;
//             height: 100%;
//             transition: transform 0.7s;
//             transform-style: preserve-3d;
//         }
//         .card-face {
//             position: absolute;
//             width: 100%;
//             height: 100%;
//             backface-visibility: hidden;
//             border-radius: 1.25rem; 
//             overflow: hidden;
//             box-shadow: 0 15px 25px -5px rgba(0, 0, 0, 0.1), 0 5px 10px -5px rgba(0, 0, 0, 0.04);
//         }
//         .card-back {
//             transform: rotateY(180deg);
//             padding: 1.5rem;
//             background-color: #fcfcfc;
//             display: flex;
//             flex-direction: column;
//             justify-content: space-between; 
//         }
//         .flipped {
//             transform: rotateY(180deg);
//         }

//         html[lang="ar"] .text-content-wrapper {
//             flex-direction: row-reverse;
//             text-align: right;
//         }
//         html[lang="en"] .text-content-wrapper {
//             flex-direction: row;
//             text-align: left;
//         }
//         .icon-small {
//             width: 1.15rem;
//             height: 1.15rem;
//             color: #1d4ed8; 
//             flex-shrink: 0;
//         }
//         /* Make location clickable stand out a bit */
//         .event-location:hover .text-content {
//             text-decoration: underline;
//             color: #1e40af; /* Dark blue on hover */
//         }
//         .event-location {
//             cursor: pointer;
//         }
//         .text-content-wrapper {
//              /* Base text style for metadata links */
//             color: #4b5563; 
//             transition: color 0.2s;
//         }

//         /* Date input style override */
//         input[type="date"]::-webkit-calendar-picker-indicator {
//             cursor: pointer;
//             filter: invert(40%) sepia(30%) saturate(2000%) hue-rotate(220deg) brightness(80%) contrast(90%);
//         }
//     </style>
// </head>
// <body class="p-4 pt-8">

//     <!-- Filter Settings Modal Overlay -->
//     <div id="filter-modal-overlay" class="modal-overlay">
//         <div id="filter-modal-content" class="modal-content">
//             <div class="flex justify-between items-center border-b pb-3 mb-4">
//                 <h2 id="modal-title" class="text-2xl font-bold text-gray-800">Filter Events</h2>
//                 <button id="close-modal-btn" class="text-gray-500 hover:text-gray-800 transition-colors">
//                     <!-- Close Icon (X) -->
//                     <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
//                 </button>
//             </div>

//             <!-- Filter Option: Event Type -->
//             <div class="mb-5">
//                 <label id="label-type" class="filter-group-label">Event Type</label>
//                 <div id="filter-type-options" class="flex flex-wrap gap-2">
//                     <!-- Options will be dynamically generated and managed by JS -->
//                 </div>
//             </div>

//             <!-- Filter Option: Age Group -->
//             <div class="mb-5">
//                 <label id="label-age" class="filter-group-label">Age Group</label>
//                 <div id="filter-age-options" class="flex flex-wrap gap-2">
//                      <!-- Options will be dynamically generated and managed by JS -->
//                 </div>
//             </div>

//             <!-- Filter Option: Date Range (Calendar Pickers) -->
//             <div class="mb-6">
//                 <label id="label-date" class="filter-group-label">Date Range</label>
//                 <div class="flex space-x-3">
//                     <div class="flex-1">
//                         <label for="startDateFilter" class="block text-xs text-gray-500 mb-1">Start Date</label>
//                         <input type="date" id="startDateFilter" class="w-full p-3 border border-gray-300 rounded-xl focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all" />
//                     </div>
//                     <div class="flex-1">
//                         <label for="endDateFilter" class="block text-xs text-gray-500 mb-1">End Date</label>
//                         <input type="date" id="endDateFilter" class="w-full p-3 border border-gray-300 rounded-xl focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all" />
//                     </div>
//                 </div>
//                 <p id="date-message" class="text-xs text-red-500 mt-2 h-4"></p>
//             </div>
            
//             <!-- Modal Action Buttons -->
//             <div class="flex justify-between space-x-3 pt-4 border-t border-gray-100">
//                 <button id="reset-filters-btn" class="flex-1 px-4 py-3 bg-gray-200 text-gray-700 font-bold rounded-full hover:bg-gray-300 transition-all">
//                     Reset
//                 </button>
//                 <button id="apply-filters-btn" class="flex-1 px-4 py-3 bg-blue-600 text-white font-bold rounded-full hover:bg-blue-700 transition-all shadow-lg">
//                     Apply Filters
//                 </button>
//             </div>
//         </div>
//     </div>


//     <!-- App Content Wrapper -->
//     <div id="app-content-wrapper" class="w-full max-w-md relative min-h-[500px]">
//         <!-- Home View (Retained) -->
//         <section id="home-view" class="page-transition page-hidden">
//             <div class="bg-white p-6 rounded-3xl shadow-2xl">
//                 <h1 id="home-title" class="text-3xl font-extrabold text-blue-700 mb-4 text-center">Home</h1>
//                 <p id="home-greeting" class="text-gray-700">Welcome to Swim 360! This is your main dashboard. Check the latest events and marketplace deals.</p>
//                 <div class="mt-6 p-4 bg-blue-50 rounded-xl shadow-inner border border-blue-100">
//                     <h3 id="stats-title" class="font-bold text-blue-800">Quick Stats</h3>
//                     <p id="stats-content" class="text-sm text-gray-600">Total Swims: 45 | Average Speed: 1.5 m/s</p>
//                 </div>
//                 <button id="language-toggle-btn" class="mt-6 w-full bg-blue-600 text-white p-3 rounded-full font-semibold hover:bg-blue-700 transition-all shadow-lg transform hover:scale-[1.01]">Toggle Language (العربية)</button>
//             </div>
//         </section>

//         <!-- Events View -->
//         <section id="events-view" class="page-transition page-active">
//             <div class="w-full max-w-md">
//                 <h1 id="events-title" class="text-3xl font-extrabold text-blue-700 mb-6 text-center">Events</h1>
                
//                 <!-- Search, Sort & Filter Controls -->
//                 <div class="mb-8 top-controls">
//                     <!-- Search Input Container -->
//                     <div class="search-container">
//                         <input type="text" id="event-search" class="search-input shadow-lg" placeholder="Search events by title..." />
//                         <!-- Search Icon (Lucide) -->
//                         <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="search-icon w-5 h-5">
//                             <circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>
//                         </svg>
//                     </div>
                    
//                     <!-- Sort Control -->
//                     <div id="sort-control-container" class="shadow-lg">
//                          <!-- Sort Icon (Lucide) -->
//                         <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 text-gray-500">
//                              <path d="M3 3h18"/><path d="m11 11 3 3 4-4"/>
//                              <path d="M12 7V3"/>
//                              <path d="M7 15h10"/>
//                              <path d="M10 19h4"/>
//                          </svg>
//                         <select id="sort-select">
//                             <option value="date-asc" id="sort-date-asc"></option>
//                             <option value="price-asc" id="sort-price-asc"></option>
//                             <option value="price-desc" id="sort-price-desc"></option>
//                         </select>
//                     </div>

//                     <!-- Filter Button -->
//                     <button id="filter-btn" class="shadow-lg">
//                         <!-- Filter Icon (Lucide) -->
//                         <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6"><path d="M22 3.5H2l8.53 10.8a1 1 0 0 1-.36 1.4L7 18.2a1 1 0 0 0 .36 1.4l5.88-5.88a1 1 0 0 1 1.41 0L22 17.5V3.5z"/></svg>
//                     </button>
//                 </div>
                
//                 <!-- Events List Container -->
//                 <div id="events-list-container" class="space-y-8">
                    
//                     <!-- Event Card 1: Regional Championship -->
//                     <div class="event-card-container" data-title="Regional Championship" data-event-id="event1" data-seats="25" data-type="championship" data-age-group="15+" data-price="45" data-sortable-date="2025-08-10" data-location-coords="40.7128,-74.0060">
//                         <div class="event-card bg-white">
//                             <!-- Card Front -->
//                             <div class="card-face card-front flex flex-col">
//                                 <!-- Image Placeholder -->
//                                 <div class="h-40 bg-cover bg-center relative" style="background-image: url('https://placehold.co/400x160/1d4ed8/ffffff?text=REGIONAL+CHAMPIONSHIP'); border-top-left-radius: 1.25rem; border-top-right-radius: 1.25rem;" onerror="this.style.backgroundColor='#1d4ed8'; this.textContent='Regional Championship'; this.classList.add('flex', 'items-center', 'justify-center', 'text-white', 'text-xl', 'font-bold');">
//                                 </div>
//                                 <div class="p-4 flex flex-col flex-grow">
//                                     <h2 id="event1-title" class="text-2xl font-extrabold text-gray-900 mb-3">Regional Championship</h2>
                                    
//                                     <!-- Event Metadata Grid (8 items in a 2-column layout) -->
//                                     <div class="grid grid-cols-2 gap-y-3 gap-x-4 text-sm text-gray-700 mb-4">
//                                         <div id="event1-date" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event1-duration" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event1-location" class="text-content-wrapper flex items-center space-x-2 event-location"></div>
//                                         <div id="event1-type" class="text-content-wrapper flex items-center space-x-2 font-medium"></div>
//                                         <div id="event1-age" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event1-price" class="text-content-wrapper flex items-center space-x-2 font-bold text-blue-600"></div>
//                                         <!-- tickets Left -->
//                                         <div id="event1-seats" class="text-content-wrapper flex items-center space-x-2 font-bold text-red-600"></div>
//                                     </div>
                                    
//                                     <div class="flex justify-between items-center mt-auto pt-4 border-t border-gray-100">
//                                         <button class="see-more-btn text-base text-blue-600 font-semibold hover:text-blue-800 transition-colors">See Details</button>
//                                         <button class="register-btn px-6 py-2 bg-green-500 text-white font-bold rounded-full text-sm hover:bg-green-600 transition-all shadow-md transform hover:scale-[1.03]">Register</button>
//                                     </div>
//                                 </div>
//                             </div>
                            
//                             <!-- Card Back -->
//                             <div class="card-face card-back">
//                                 <div class="overflow-y-auto max-h-[85%]">
//                                     <h3 class="text-xl font-bold text-blue-700 mb-2" id="event1-back-title">Description</h3>
//                                     <p id="event1-description" class="text-gray-700 text-sm leading-relaxed">This is the premier swimming event of the season, featuring top athletes from five regions competing for the coveted gold medal. All ages and skill levels are welcome to watch and participate in support activities. Sign up now!</p>
//                                 </div>
//                                 <div class="mt-4 flex justify-between items-center pt-2 border-t border-gray-300">
//                                     <button class="see-less-btn text-sm text-blue-600 font-semibold hover:text-blue-800 transition-colors">Go Back</button>
//                                     <button class="register-btn px-6 py-2 bg-green-500 text-white font-bold rounded-full text-sm hover:bg-green-600 transition-all shadow-md transform hover:scale-[1.03]">Register</button>
//                                 </div>
//                             </div>
//                         </div>
//                     </div>
                    
//                     <!-- Event Card 2: Open Water Fun Swim -->
//                     <div class="event-card-container" data-title="Open Water Fun Swim" data-event-id="event2" data-seats="10" data-type="fun-swim" data-age-group="all-ages" data-price="0" data-sortable-date="2025-09-05" data-location-coords="34.0522,-118.2437">
//                         <div class="event-card bg-white">
//                             <!-- Card Front -->
//                             <div class="card-face card-front flex flex-col">
//                                 <!-- Image Placeholder -->
//                                 <div class="h-40 bg-cover bg-center relative" style="background-image: url('https://placehold.co/400x160/ef4444/ffffff?text=OPEN+WATER+SWIM'); border-top-left-radius: 1.25rem; border-top-right-radius: 1.25rem;" onerror="this.style.backgroundColor='#ef4444'; this.textContent='Open Water Fun Swim'; this.classList.add('flex', 'items-center', 'justify-center', 'text-white', 'text-xl', 'font-bold');">
//                                 </div>
//                                 <div class="p-4 flex flex-col flex-grow">
//                                     <h2 id="event2-title" class="text-2xl font-extrabold text-gray-900 mb-3">Open Water Fun Swim</h2>
                                    
//                                     <!-- Event Metadata Grid (8 items) -->
//                                     <div class="grid grid-cols-2 gap-y-3 gap-x-4 text-sm text-gray-700 mb-4">
//                                         <div id="event2-date" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event2-duration" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event2-location" class="text-content-wrapper flex items-center space-x-2 event-location"></div>
//                                         <div id="event2-type" class="text-content-wrapper flex items-center space-x-2 font-medium"></div>
//                                         <div id="event2-age" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event2-price" class="text-content-wrapper flex items-center space-x-2 font-bold text-blue-600"></div>
//                                         <!-- Seats Left -->
//                                         <div id="event2-seats" class="text-content-wrapper flex items-center space-x-2 font-bold text-red-600"></div>
//                                     </div>

//                                     <div class="flex justify-between items-center mt-auto pt-4 border-t border-gray-100">
//                                         <button class="see-more-btn text-base text-blue-600 font-semibold hover:text-blue-800 transition-colors">See Details</button>
//                                         <button class="register-btn px-6 py-2 bg-green-500 text-white font-bold rounded-full text-sm hover:bg-green-600 transition-all shadow-md transform hover:scale-[1.03]">Register</button>
//                                     </div>
//                                 </div>
//                             </div>
                            
//                             <!-- Card Back -->
//                             <div class="card-face card-back">
//                                 <div class="overflow-y-auto max-h-[85%]">
//                                     <h3 class="text-xl font-bold text-blue-700 mb-2" id="event2-back-title">Description</h3>
//                                     <p id="event2-description" class="text-gray-700 text-sm leading-relaxed">A social and non-competitive open water swimming event perfect for all levels. Wetsuits are encouraged. Meet at the main beach flagpole. Snacks and warm drinks provided afterwards!</p>
//                                 </div>
//                                 <div class="mt-4 flex justify-between items-center pt-2 border-t border-gray-300">
//                                     <button class="see-less-btn text-sm text-blue-600 font-semibold hover:text-blue-800 transition-colors">Go Back</button>
//                                     <button class="register-btn px-6 py-2 bg-green-500 text-white font-bold rounded-full text-sm hover:bg-green-600 transition-all shadow-md transform hover:scale-[1.03]">Register</button>
//                                 </div>
//                             </div>
//                         </div>
//                     </div>
                    
//                     <!-- Event Card 3: Masters Training Session -->
//                     <div class="event-card-container" data-title="Masters Training Session" data-event-id="event3" data-seats="4" data-type="training" data-age-group="adults" data-price="15" data-sortable-date="2025-12-01" data-location-coords="51.5074,-0.1278">
//                         <div class="event-card bg-white">
//                             <!-- Card Front -->
//                             <div class="card-face card-front flex flex-col">
//                                 <!-- Image Placeholder -->
//                                 <div class="h-40 bg-cover bg-center relative" style="background-image: url('https://placehold.co/400x160/059669/ffffff?text=TRAINING+SESSION'); border-top-left-radius: 1.25rem; border-top-right-radius: 1.25rem;" onerror="this.style.backgroundColor='#059669'; this.textContent='Masters Training Session'; this.classList.add('flex', 'items-center', 'justify-center', 'text-white', 'text-xl', 'font-bold');">
//                                 </div>
//                                 <div class="p-4 flex flex-col flex-grow">
//                                     <h2 id="event3-title" class="text-2xl font-extrabold text-gray-900 mb-3">Masters Training Session</h2>
                                    
//                                     <!-- Event Metadata Grid (8 items) -->
//                                     <div class="grid grid-cols-2 gap-y-3 gap-x-4 text-sm text-gray-700 mb-4">
//                                         <div id="event3-date" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event3-duration" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event3-location" class="text-content-wrapper flex items-center space-x-2 event-location"></div>
//                                         <div id="event3-type" class="text-content-wrapper flex items-center space-x-2 font-medium"></div>
//                                         <div id="event3-age" class="text-content-wrapper flex items-center space-x-2"></div>
//                                         <div id="event3-price" class="text-content-wrapper flex items-center space-x-2 font-bold text-blue-600"></div>
//                                         <!-- Seats Left -->
//                                         <div id="event3-seats" class="text-content-wrapper flex items-center space-x-2 font-bold text-red-600"></div>
//                                     </div>

//                                     <div class="flex justify-between items-center mt-auto pt-4 border-t border-gray-100">
//                                         <button class="see-more-btn text-base text-blue-600 font-semibold hover:text-blue-800 transition-colors">See Details</button>
//                                         <button class="register-btn px-6 py-2 bg-green-500 text-white font-bold rounded-full text-sm hover:bg-green-600 transition-all shadow-md transform hover:scale-[1.03]">Register</button>
//                                     </div>
//                                 </div>
//                             </div>
                            
//                             <!-- Card Back -->
//                             <div class="card-face card-back">
//                                 <div class="overflow-y-auto max-h-[85%]">
//                                     <h3 class="text-xl font-bold text-blue-700 mb-2" id="event3-back-title">Description</h3>
//                                     <p id="event3-description" class="text-gray-700 text-sm leading-relaxed">Focused training for competitive swimmers aged 25+. High-intensity intervals and technique drills led by Coach Sarah. Drop-in available for $15. Secure your spot early!</p>
//                                 </div>
//                                 <div class="mt-4 flex justify-between items-center pt-2 border-t border-gray-300">
//                                     <button class="see-less-btn text-sm text-blue-600 font-semibold hover:text-blue-800 transition-colors">Go Back</button>
//                                     <button class="register-btn px-6 py-2 bg-green-500 text-white font-bold rounded-full text-sm hover:bg-green-600 transition-all shadow-md transform hover:scale-[1.03]">Register</button>
//                                 </div>
//                             </div>
//                         </div>
//                     </div>

//                 </div>
//             </div>
//         </section>

//         <!-- Marketplace View (Retained) -->
//         <section id="marketplace-view" class="page-transition page-hidden">
//             <div class="bg-white p-6 rounded-3xl shadow-2xl">
//                 <h1 id="marketplace-title" class="text-3xl font-extrabold text-blue-700 mb-4 text-center">Marketplace</h1>
//                 <p id="marketplace-info" class="text-gray-700">Buy and sell swimming gear, equipment, and training services.</p>
//                 <div class="grid grid-cols-2 gap-4 mt-6">
//                     <div class="border p-4 rounded-xl text-center shadow-md bg-gray-50 hover:bg-white transition duration-300">
//                         <span class="text-4xl">🏊</span>
//                         <p id="item-1" class="text-sm font-semibold mt-2 text-gray-800">Racing Goggles</p>
//                     </div>
//                     <div class="border p-4 rounded-xl text-center shadow-md bg-gray-50 hover:bg-white transition duration-300">
//                         <span class="text-4xl">👟</span>
//                         <p id="item-2" class="text-sm font-semibold mt-2 text-gray-800">Used Fins</p>
//                     </div>
//                     <div class="border p-4 rounded-xl text-center shadow-md bg-gray-50 hover:bg-white transition duration-300">
//                         <span class="text-4xl">⏱️</span>
//                         <p id="item-3" class="text-sm font-semibold mt-2 text-gray-800">Stopwatches</p>
//                     </div>
//                     <div class="border p-4 rounded-xl text-center shadow-md bg-gray-50 hover:bg-white transition duration-300">
//                         <span class="text-4xl">🧴</span>
//                         <p id="item-4" class="text-sm font-semibold mt-2 text-gray-800">Sunscreen Bulk</p>
//                     </div>
//                 </div>
//             </div>
//         </section>

//         <!-- Profile View (Retained) -->
//         <section id="profile-view" class="page-transition page-hidden">
//             <div class="bg-white p-6 rounded-3xl shadow-2xl">
//                 <h1 id="profile-title" class="text-3xl font-extrabold text-blue-700 mb-4 text-center">Profile</h1>
//                 <p id="profile-info" class="text-gray-700">Manage your account details and view your swimming history.</p>
//                 <ul class="mt-6 space-y-4 p-4 bg-gray-50 rounded-xl shadow-inner border border-gray-100">
//                     <li id="profile-name" class="text-gray-700 border-b pb-3">Name: John Doe</li>
//                     <li id="profile-level" class="text-gray-700 border-b pb-3">Level: Advanced</li>
//                     <li id="profile-team" class="text-gray-700">Team: Blue Sharks</li>
//                 </ul>
//             </div>
//         </section>
//     </div>

//     <!-- Mobile Navigation Bar (Retained) -->
//     <nav id="nav-bar" class="fixed bottom-0 left-0 right-0 h-16 bg-white border-t border-gray-200 shadow-[0_-5px_15px_-3px_rgba(0,0,0,0.1)] flex justify-around items-center max-w-md mx-auto rounded-t-2xl z-40">
//         <!-- Home Link -->
//         <a href="#" id="nav-home-link" data-view="home" class="nav-item flex flex-col items-center text-gray-500 hover:text-blue-700 transition-colors text-xs p-2 duration-200">
//             <!-- Icon: Home (Lucide) -->
//             <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
//                 <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
//                 <polyline points="9 22 9 12 15 12 15 22"/>
//             </svg>
//             <span id="nav-home" class="font-medium">Home</span>
//         </a>

//         <!-- Events Link (Active) -->
//         <a href="#" id="nav-events-link" data-view="events" class="nav-item active flex flex-col items-center text-xs p-2 transition-colors duration-200">
//             <!-- Icon: Calendar/Events (Lucide) -->
//             <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
//                 <rect width="18" height="18" x="3" y="4" rx="2" ry="2"/>
//                 <line x1="16" x2="16" y1="2" y2="6"/>
//                 <line x1="8" x2="8" y1="2" y2="6"/>
//                 <line x1="3" x2="21" y1="10" y2="10"/>
//             </svg>
//             <span id="nav-events" class="font-medium">Events</span>
//         </a>

//         <!-- Marketplace Link -->
//         <a href="#" id="nav-marketplace-link" data-view="marketplace" class="nav-item flex flex-col items-center text-gray-500 hover:text-blue-700 transition-colors text-xs p-2">
//             <!-- Icon: Shopping Cart (Lucide) -->
//             <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
//                 <circle cx="8" cy="20.5" r="1"/>
//                 <circle cx="17" cy="20.5" r="1"/>
//                 <path d="M7.647 15.932l-3.238-12.951A.5.5 0 0 0 4 3h-1"/>
//                 <path d="m6.07 14.549 14.28 1.428a.5.5 0 0 0 .584-.367L22 5H5.2"/>
//             </svg>
//             <span id="nav-marketplace" class="font-medium">Marketplace</span>
//         </a>

//         <!-- Profile Link -->
//         <a href="#" id="nav-profile-link" data-view="profile" class="nav-item flex flex-col items-center text-gray-500 hover:text-blue-700 transition-colors text-xs p-2">
//             <!-- Icon: User/Profile (Lucide) -->
//             <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
//                 <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
//                 <circle cx="12" cy="7" r="4"/>
//             </svg>
//             <span id="nav-profile" class="font-medium">Profile</span>
//         </a>
//     </nav>


//     <script>
//         // --- STATE, ICONS, AND TRANSLATION DATA ---
//         let currentLang = 'en';
//         let currentView = 'events';
        
//         let currentFilters = {
//             search: '',
//             type: 'all',
//             age: 'all',
//             startDate: '', 
//             endDate: '',
//             // New state for sorting
//             sortBy: 'date-asc' // Default sort: date ascending
//         };

//         const filterOptions = {
//             type: [
//                 { value: 'all', en: 'All Types', ar: 'جميع الأنواع' },
//                 { value: 'championship', en: 'Championship', ar: 'بطولة' },
//                 { value: 'fun-swim', en: 'Fun Swim', ar: 'سباحة ترفيهية' },
//                 { value: 'training', en: 'Training Clinic', ar: 'عيادة تدريب' }
//             ],
//             age: [
//                 { value: 'all', en: 'All Ages', ar: 'جميع الأعمار' },
//                 { value: 'kids', en: 'Kids (10-)', ar: 'أطفال (10-)' },
//                 { value: '15+', en: '15+', ar: '15+' },
//                 { value: 'all-ages', en: 'All Ages', ar: 'جميع الأعمار' },
//                 { value: 'adults', en: 'Adults (25+)', ar: 'بالغون (25+)' }
//             ],
//             sort: {
//                 'date-asc': { en: 'Date (Soonest)', ar: 'التاريخ (الأقرب)' },
//                 'price-asc': { en: 'Price (Lowest)', ar: 'السعر (الأدنى)' },
//                 'price-desc': { en: 'Price (Highest)', ar: 'السعر (الأعلى)' }
//             }
//         };
        

//         // Lucide Icons (as SVG strings)
//         const icons = {
//             date: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-small"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>`,
//             duration: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-small"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>`,
//             location: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-small"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z"/><circle cx="12" cy="10" r="3"/></svg>`,
//             type: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-small"><path d="M14.5 9.5a3 3 0 1 0-5 5L7 17l4 4 4-4 2.5-2.5"/><path d="m15 5 4 4"/><path d="m20 2 2 2"/><path d="M5 15.5 2 18.5"/><path d="M4 16 2 18"/><path d="m17 7 3-3"/><path d="m20 4 2 2"/><path d="m2 22 2-2"/><path d="m7 17-2 2"/><path d="m11 11-2 2"/></svg>`,
//             age: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-small"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>`,
//             seats: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-small"><path d="M2 17a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-3H2v3z"/><path d="M7 11V6a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v5"/><line x1="12" y1="14" x2="12" y2="19"/></svg>`,
//             // New icon for price
//             price: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-small"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>`
//         };
        
//         const translations = {
//             en: {
//                 homeTitle: "Home", eventsTitle: "Events", marketplaceTitle: "Marketplace", profileTitle: "Profile",
//                 navHome: "Home", navEvents: "Events", navMarketplace: "Marketplace", navProfile: "Profile",
//                 homeGreeting: "Welcome to Swim 360! This is your main dashboard. Check the latest events and marketplace deals.",
//                 statsTitle: "Quick Stats", statsContent: "Total Swims: 45 | Average Speed: 1.5 m/s",
//                 toggleBtn: "Toggle Language (العربية)",
//                 searchPlaceholder: "Search events by title...",
//                 seeMore: "See Details",
//                 seeLess: "Go Back",
//                 descriptionTitle: "Description",
//                 registerBtn: "Register",
//                 registeredMsg: "Registered!",
//                 soldOutMsg: "Sold Out",
//                 currency: "$", // US Dollar

//                 // Sort options
//                 sortDateAsc: "Date (Soonest)",
//                 sortPriceAsc: "Price (Lowest)",
//                 sortPriceDesc: "Price (Highest)",
                
//                 // Modal Text
//                 modalTitle: "Filter Events",
//                 labelType: "Event Type",
//                 labelAge: "Age Group",
//                 labelDate: "Date Range",
//                 resetBtn: "Reset",
//                 applyBtn: "Apply Filters",

//                 // Event 1 (Regional Championship)
//                 event1Title: "Regional Championship", 
//                 event1DateText: "Aug 10th 2025", 
//                 event1DurationText: "9:00 AM | 3 hrs",
//                 event1LocationText: "Central Pool (NYC)",
//                 event1TypeText: "Championship",
//                 event1AgeText: "15+ & Adults",
//                 event1SeatsText: "Seats Left",
//                 event1Description: "This is the premier swimming event of the season, featuring top athletes from five regions competing for the coveted gold medal. All ages and skill levels are welcome to watch and participate in support activities. Sign up now!",
                
//                 // Event 2 (Open Water Fun Swim)
//                 event2Title: "Open Water Fun Swim",
//                 event2DateText: "Sep 5th 2025",
//                 event2DurationText: "8:30 AM | 2 hours",
//                 event2LocationText: "Sea Coast (LA)",
//                 event2TypeText: "Fun Swim",
//                 event2AgeText: "All Ages",
//                 event2SeatsText: "Seats Left",
//                 event2Description: "A social and non-competitive open water swimming event perfect for all levels. Wetsuits are encouraged. Meet at the main beach flagpole. Snacks and warm drinks provided afterwards!",

//                 // Event 3 (Masters Training Session)
//                 event3Title: "Masters Training Session",
//                 event3DateText: "Dec 1st 2025",
//                 event3DurationText: "7:00 PM | 90 mins",
//                 event3LocationText: "Local Gym Pool (LON)",
//                 event3TypeText: "Training Clinic",
//                 event3AgeText: "25+",
//                 event3SeatsText: "Seats Left",
//                 event3Description: "Focused training for competitive swimmers aged 25+. High-intensity intervals and technique drills led by Coach Sarah. Drop-in available for $15. Secure your spot early!",

//                 marketplaceInfo: "Buy and sell swimming gear, equipment, and training services.",
//                 item1: "Racing Goggles", item2: "Used Fins", item3: "Stopwatches", item4: "Sunscreen Bulk",
//                 profileInfo: "Manage your account details and view your swimming history.",
//                 profileName: "Name: John Doe", profileLevel: "Level: Advanced", profileTeam: "Team: Blue Sharks",
//             },
//             ar: {
//                 homeTitle: "الرئيسية", eventsTitle: "الفعاليات", marketplaceTitle: "السوق", profileTitle: "الملف الشخصي",
//                 navHome: "الرئيسية", navEvents: "الفعاليات", navMarketplace: "السوق", navProfile: "الملف الشخصي",
//                 homeGreeting: "مرحباً بك في Swim 360! هذه هي لوحة القيادة الرئيسية الخاصة بك. اطلع على أحدث الفعاليات وعروض السوق.",
//                 statsTitle: "إحصائيات سريعة", statsContent: "إجمالي السباحات: $٤٥$ | متوسط السرعة: $١.٥$ متر/ثانية",
//                 toggleBtn: "تبديل اللغة (English)",
//                 searchPlaceholder: "ابحث عن الفعاليات حسب العنوان...",
//                 seeMore: "رؤية التفاصيل", seeLess: "العودة", descriptionTitle: "الوصف", registerBtn: "تسجيل",
//                 registeredMsg: "تم التسجيل!",
//                 soldOutMsg: "نفدت المقاعد",
//                 currency: "ر.س", // Saudi Riyal

//                 // Sort options
//                 sortDateAsc: "التاريخ (الأقرب)",
//                 sortPriceAsc: "السعر (الأدنى)",
//                 sortPriceDesc: "السعر (الأعلى)",

//                 // Modal Text
//                 modalTitle: "تصفية الفعاليات",
//                 labelType: "نوع الفعالية",
//                 labelAge: "الفئة العمرية",
//                 labelDate: "نطاق التاريخ",
//                 resetBtn: "إعادة تعيين",
//                 applyBtn: "تطبيق التصفية",
                
//                 // Event 1
//                 event1Title: "بطولة إقليمية",
//                 event1DateText: "$١٠$ أغسطس $٢٠٢٥$",
//                 event1DurationText: "$٩:٠٠$ ص | $٣$ ساعات",
//                 event1LocationText: "المسبح المركزي (NYC)",
//                 event1TypeText: "بطولة",
//                 event1AgeText: "$١٥+$ وبالغون",
//                 event1SeatsText: "مقاعد متبقية",
//                 event1Description: "هذا هو الحدث الأبرز للسباحة هذا الموسم، يضم نخبة من الرياضيين من خمس مناطق يتنافسون على الميدالية الذهبية المرموقة. نرحب بجميع الأعمار ومستويات المهارة للمشاهدة والمشاركة في الأنشطة الداعمة. سجل الآن!",

//                 // Event 2
//                 event2Title: "سباحة ترفيهية في المياه المفتوحة",
//                 event2DateText: "$٥$ سبتمبر $٢٠٢٥$",
//                 event2DurationText: "$٨:٣٠$ ص | $٢$ ساعات",
//                 event2LocationText: "شاطئ البحر (LA)",
//                 event2TypeText: "سباحة ترفيهية",
//                 event2AgeText: "جميع الأعمار",
//                 event2SeatsText: "مقاعد متبقية",
//                 event2Description: "فعالية سباحة اجتماعية وغير تنافسية في المياه المفتوحة مثالية لجميع المستويات. نشجع على ارتداء بدلات الغوص. التجمع عند سارية العلم الرئيسية على الشاطئ. يتم توفير الوجبات الخفيفة والمشروبات الدافئة لاحقاً!",

//                 // Event 3
//                 event3Title: "جلسة تدريب للمحترفين",
//                 event3DateText: "$١$ ديسمبر $٢٠٢٥$",
//                 event3DurationText: "$٧:٠٠$ م | $٩٠$ دقيقة",
//                 event3LocationText: "مسبح النادي المحلي (LON)",
//                 event3TypeText: "عيادة تدريب",
//                 event3AgeText: "$٢٥+$",
//                 event3SeatsText: "مقاعد متبقية",
//                 event3Description: "تدريب مركز للسباحين المتنافسين الذين تتراوح أعمارهم بين $٢٥+$ فما فوق. تدريبات متكررة عالية الكثافة وتمارين تقنية بقيادة المدربة سارة. Drop-in متاح مقابل $١٥$ دولار. احجز مكانك مبكراً!",

//                 marketplaceInfo: "قم بشراء وبيع معدات السباحة والمعدات والخدمات التدريبية.",
//                 item1: "نظارات سباحة للسباق", item2: "زعانف مستعملة", item3: "ساعات توقيت", item4: "كريم واقي من الشمس بالجملة",
//                 profileInfo: "إدارة تفاصيل حسابك وعرض سجل السباحة الخاص بك.",
//                 profileName: "الاسم: جون دو", profileLevel: "المستوى: متقدم", profileTeam: "الفريق: أسماك القرش الزرقاء",
//             }
//         };

//         /**
//          * Renders the event metadata (date, duration, location, type, age, seats, price)
//          */
//         function renderEventMetadata(eventId, t, isRTL) {
//             const container = document.querySelector(`.event-card-container[data-event-id="${eventId}"]`);
//             const seatsLeft = container ? container.getAttribute('data-seats') : 'N/A';
//             const priceValue = container ? container.getAttribute('data-price') : '0';
//             const coords = container ? container.getAttribute('data-location-coords') : null;
            
//             const seatsLabel = t[`${eventId}SeatsText`]; 
//             const priceText = priceValue === '0' ? 'FREE' : `${t.currency}${priceValue}`;

//             const data = {
//                 date: t[`${eventId}DateText`],
//                 duration: t[`${eventId}DurationText`],
//                 location: t[`${eventId}LocationText`],
//                 type: t[`${eventId}TypeText`],
//                 age: t[`${eventId}AgeText`],
//                 seats: `${seatsLeft} ${seatsLabel}`,
//                 price: priceText, // New Price Field
//             };

//             const metadataIds = ['date', 'duration', 'location', 'type', 'age', 'price', 'seats'];
            
//             metadataIds.forEach(key => {
//                 const element = document.getElementById(`${eventId}-${key}`);
//                 if (element) {
//                     // Inject Icon + Text Content
//                     element.innerHTML = `${icons[key]}<span class="text-content">${data[key]}</span>`;

//                     // Handle RTL/LTR spacing: space-x-2 is LTR, space-x-reverse is RTL
//                     element.classList.remove('space-x-2', 'space-x-reverse');
//                     if (isRTL) {
//                         element.classList.add('space-x-2', 'space-x-reverse');
//                     } else {
//                         element.classList.add('space-x-2');
//                     }
                    
//                     // Add click handler for Location to open map
//                     if (key === 'location' && coords) {
//                         element.onclick = () => handleLocationClick(coords);
//                     }
//                 }
//             });
            
//             // Update button state (Registered/Sold Out)
//             const registerButtons = container.querySelectorAll('.register-btn');
//             if (parseInt(seatsLeft, 10) <= 0) {
//                 registerButtons.forEach(btn => {
//                      btn.textContent = t.soldOutMsg;
//                      btn.disabled = true;
//                      btn.classList.remove('bg-green-500', 'hover:bg-green-600', 'transform', 'hover:scale-[1.03]');
//                      btn.classList.add('bg-red-500', 'opacity-70', 'cursor-not-allowed');
//                 });
//             } else {
//                  registerButtons.forEach(btn => {
//                      btn.textContent = t.registerBtn;
//                      btn.disabled = false;
//                      btn.classList.remove('bg-red-500', 'opacity-70', 'cursor-not-allowed', 'bg-blue-500', 'hover:bg-blue-600', 'cursor-default');
//                      btn.classList.add('bg-green-500', 'hover:bg-green-600', 'transform', 'hover:scale-[1.03]');
//                 });
//             }
//         }

//         /**
//          * Opens Google Maps for the given coordinates.
//          */
//         function handleLocationClick(coords) {
//             if (coords) {
//                 // Format: lat,lng
//                 const mapUrl = `https://www.google.com/maps/search/?api=1&query=${coords}`;
//                 window.open(mapUrl, '_blank');
//             }
//         }

//         /**
//          * Renders the filter options (Type and Age) and Sort options into the modal based on current language.
//          */
//         function renderFilterOptions(lang) {
//             const t = translations[lang];
            
//             // --- Render Type Options --- (Same as before)
//             const typeContainer = document.getElementById('filter-type-options');
//             typeContainer.innerHTML = filterOptions.type.map(option => `
//                 <button class="option-tag" data-filter-group="type" data-filter-value="${option.value}">
//                     ${option[lang]}
//                 </button>
//             `).join('');

//             // --- Render Age Options --- (Same as before)
//             const ageContainer = document.getElementById('filter-age-options');
//             ageContainer.innerHTML = filterOptions.age.map(option => `
//                 <button class="option-tag" data-filter-group="age" data-filter-value="${option.value}">
//                     ${option[lang]}
//                 </button>
//             `).join('');
            
//             // --- Update Sort Options ---
//             document.getElementById('sort-date-asc').textContent = t.sortDateAsc;
//             document.getElementById('sort-price-asc').textContent = t.sortPriceAsc;
//             document.getElementById('sort-price-desc').textContent = t.sortPriceDesc;

//             // Add click listeners to the new tags
//             document.querySelectorAll('.option-tag').forEach(tag => {
//                 tag.addEventListener('click', handleFilterTagClick);
//             });

//             // Update modal UI based on currentFilters state
//             updateModalUI();
//         }

//         /**
//          * Updates all text content for the current language.
//          */
//         function updateContent(lang) {
//             const t = translations[lang];
//             const isRTL = lang === 'ar';
            
//             // Set document language and direction
//             document.documentElement.lang = lang;
//             document.body.style.direction = isRTL ? 'rtl' : 'ltr';

//             // --- Apply text alignments for RTL/LTR ---
//             const alignmentClass = isRTL ? 'text-right' : 'text-left';
//             document.querySelectorAll('#app-content-wrapper section p, #app-content-wrapper section li, .bg-blue-50 h3, .bg-blue-50 p, .card-face p').forEach(el => {
//                 el.classList.remove('text-left', 'text-right');
//                 el.classList.add(alignmentClass);
//             });
//             document.querySelectorAll('h1').forEach(h1 => h1.classList.add('text-center'));
            
//             // --- Update Content ---
            
//             // Modal Text
//             document.getElementById('modal-title').textContent = t.modalTitle;
//             document.getElementById('label-type').textContent = t.labelType;
//             document.getElementById('label-age').textContent = t.labelAge;
//             document.getElementById('label-date').textContent = t.labelDate;
//             document.getElementById('reset-filters-btn').textContent = t.resetBtn;
//             document.getElementById('apply-filters-btn').textContent = t.applyBtn;
            
//             // View Titles and Navigation
//             document.getElementById('home-title').textContent = t.homeTitle;
//             document.getElementById('events-title').textContent = t.eventsTitle;
//             document.getElementById('marketplace-title').textContent = t.marketplaceTitle;
//             document.getElementById('profile-title').textContent = t.profileTitle;
//             document.getElementById('nav-home').textContent = t.navHome;
//             document.getElementById('nav-events').textContent = t.navEvents;
//             document.getElementById('nav-marketplace').textContent = t.navMarketplace;
//             document.getElementById('nav-profile').textContent = t.navProfile;

//             // Home View
//             document.getElementById('home-greeting').textContent = t.homeGreeting;
//             document.getElementById('stats-title').textContent = t.statsTitle;
//             document.getElementById('stats-content').textContent = t.statsContent;
//             document.getElementById('language-toggle-btn').textContent = t.toggleBtn;

//             // Events View
//             document.getElementById('event-search').placeholder = t.searchPlaceholder;
            
//             // Render filter/sort options with new language text
//             renderFilterOptions(lang);
//             document.getElementById('sort-select').value = currentFilters.sortBy;


//             // Update event card metadata and titles
//             document.getElementById('event1-title').textContent = t.event1Title; 
//             document.getElementById('event1-description').textContent = t.event1Description;
//             document.getElementById('event1-back-title').textContent = t.descriptionTitle;
//             renderEventMetadata('event1', t, isRTL);
//             document.getElementById('event2-title').textContent = t.event2Title;
//             document.getElementById('event2-description').textContent = t.event2Description;
//             document.getElementById('event2-back-title').textContent = t.descriptionTitle;
//             renderEventMetadata('event2', t, isRTL);
//             document.getElementById('event3-title').textContent = t.event3Title;
//             document.getElementById('event3-description').textContent = t.event3Description;
//             document.getElementById('event3-back-title').textContent = t.descriptionTitle;
//             renderEventMetadata('event3', t, isRTL);

//             // Card buttons
//             document.querySelectorAll('.see-more-btn').forEach(btn => btn.textContent = t.seeMore);
//             document.querySelectorAll('.see-less-btn').forEach(btn => btn.textContent = t.seeLess);
            
//             // Marketplace View
//             document.getElementById('marketplace-info').textContent = t.marketplaceInfo;
//             document.getElementById('item-1').textContent = t.item1;
//             document.getElementById('item-2').textContent = t.item2;
//             document.getElementById('item-3').textContent = t.item3;
//             document.getElementById('item-4').textContent = t.item4;

//             // Profile View
//             document.getElementById('profile-info').textContent = t.profileInfo;
//             document.getElementById('profile-name').textContent = t.profileName;
//             document.getElementById('profile-level').textContent = t.profileLevel;
//             document.getElementById('profile-team').textContent = t.profileTeam;

//             currentLang = lang;
//         }


//         // --- SORTING LOGIC ---
//         /**
//          * Sorts the event list container elements based on the current sort criteria.
//          */
//         function sortEvents() {
//             const container = document.getElementById('events-list-container');
//             const events = Array.from(container.querySelectorAll('.event-card-container'));
//             const sortBy = currentFilters.sortBy;
            
//             events.sort((a, b) => {
//                 let valA, valB;
//                 let isAsc = sortBy.endsWith('-asc');
                
//                 switch (sortBy) {
//                     case 'date-asc':
//                         // Sort by date (oldest/soonest first)
//                         valA = new Date(a.getAttribute('data-sortable-date') || '9999-12-31').getTime();
//                         valB = new Date(b.getAttribute('data-sortable-date') || '9999-12-31').getTime();
//                         return valA - valB;
                        
//                     case 'price-asc':
//                     case 'price-desc':
//                         // Sort by price (numeric)
//                         valA = parseFloat(a.getAttribute('data-price') || '0');
//                         valB = parseFloat(b.getAttribute('data-price') || '0');
                        
//                         if (isAsc) return valA - valB;
//                         return valB - valA;
                        
//                     default:
//                         return 0;
//                 }
//             });

//             // Re-append elements to the container in the new sorted order
//             events.forEach(event => container.appendChild(event));
//         }


//         // --- FILTERING LOGIC ---
        
//         /**
//          * Toggles the filter modal visibility.
//          */
//         function toggleFilterModal(show) {
//             const modalOverlay = document.getElementById('filter-modal-overlay');
//             const startDateFilter = document.getElementById('startDateFilter');
//             const endDateFilter = document.getElementById('endDateFilter');

//             if (show) {
//                 // Read current filter state into modal UI when opening
//                 startDateFilter.value = currentFilters.startDate;
//                 endDateFilter.value = currentFilters.endDate;
                
//                 // Set min for endDate based on current startDate
//                 endDateFilter.min = currentFilters.startDate || '';

//                 updateModalUI(); 
//                 modalOverlay.classList.add('active');
//             } else {
//                 modalOverlay.classList.remove('active');
//             }
//         }
        
//         /**
//          * Handles filter tag clicks inside the modal to update the temporary state.
//          */
//         function handleFilterTagClick(e) {
//             const tag = e.currentTarget;
//             const group = tag.getAttribute('data-filter-group');
//             const value = tag.getAttribute('data-filter-value');
            
//             if (group && currentFilters.hasOwnProperty(group)) {
                
//                 if (value === 'all') {
//                     currentFilters[group] = 'all';
//                 } else {
//                     currentFilters[group] = value;
//                 }
//             }
//             updateModalUI(); // Update UI immediately based on temporary state
//         }
        
//         /**
//          * Updates the visual state of the tags inside the modal to reflect `currentFilters`.
//          */
//         function updateModalUI() {
//             document.querySelectorAll('.option-tag').forEach(tag => {
//                 const group = tag.getAttribute('data-filter-group');
//                 const value = tag.getAttribute('data-filter-value');
                
//                 tag.classList.remove('selected');

//                 if (currentFilters[group] === value) {
//                     tag.classList.add('selected');
//                 } 
//                 // Special case: if the filter is 'all', ensure the 'all' tag is selected
//                 if (currentFilters[group] === 'all' && value === 'all') {
//                     tag.classList.add('selected');
//                 }
//             });
//         }


//         /**
//          * Applies the filters and updates the event list display.
//          */
//         function applyFilters() {
//             const startDateFilter = document.getElementById('startDateFilter');
//             const endDateFilter = document.getElementById('endDateFilter');
//             const dateMessage = document.getElementById('date-message');
            
//             dateMessage.textContent = '';
            
//             const startDate = startDateFilter.value;
//             const endDate = endDateFilter.value;
            
//             // Date Validation
//             if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
//                  dateMessage.textContent = 'Start Date cannot be after End Date.';
//                  return; 
//             }
            
//             // 1. Capture date range
//             currentFilters.startDate = startDate;
//             currentFilters.endDate = endDate;
            
//             // 2. Hide the modal
//             toggleFilterModal(false);
            
//             // 3. Get the current search term
//             const searchTerm = document.getElementById('event-search').value;

//             // 4. Apply combined filtering and sorting
//             filterEvents(searchTerm, currentFilters);
//             sortEvents(); // Re-sort after filtering
//         }

//         /**
//          * Resets the filter state and applies the filter.
//          */
//         function resetFilters() {
//             currentFilters = {
//                 search: currentFilters.search, // Keep search term, reset others
//                 type: 'all',
//                 age: 'all',
//                 startDate: '',
//                 endDate: '',
//                 sortBy: 'date-asc' // Reset sort to default
//             };
            
//             // Reset UI elements
//             document.getElementById('startDateFilter').value = '';
//             document.getElementById('endDateFilter').value = '';
//             document.getElementById('sort-select').value = 'date-asc';
//             document.getElementById('date-message').textContent = '';
            
//             applyFilters(); 
//         }
        
//         /**
//          * Filters the event cards based on search input AND current modal filters.
//          */
//         function filterEvents(searchTerm, filters) {
//             const eventContainers = document.querySelectorAll('.event-card-container');
//             const query = (searchTerm || '').toLowerCase();
            
//             // Prepare date filters
//             const filterStart = filters.startDate ? new Date(filters.startDate) : null;
//             const filterEnd = filters.endDate ? new Date(filters.endDate) : null;

//             // Normalize filter end date to end of day for inclusive filtering
//             if (filterEnd) {
//                 filterEnd.setHours(23, 59, 59, 999);
//             }
            
//             eventContainers.forEach(container => {
//                 const title = container.getAttribute('data-title').toLowerCase();
//                 const eventType = container.getAttribute('data-type');
//                 const ageGroup = container.getAttribute('data-age-group');
//                 const eventDateStr = container.getAttribute('data-sortable-date'); // YYYY-MM-DD format
                
//                 // 1. Search filter (Title match)
//                 const matchesSearch = title.includes(query);

//                 // 2. Type filter
//                 const matchesType = filters.type === 'all' || eventType === filters.type;
                
//                 // 3. Age filter
//                 const matchesAge = filters.age === 'all' || ageGroup === filters.age;

//                 // 4. Date range filter
//                 let matchesDate = true;

//                 if (filterStart || filterEnd) {
//                     if (eventDateStr) {
//                         const eventDate = new Date(eventDateStr);
//                         eventDate.setHours(0, 0, 0, 0); // Normalize event date to start of day
                        
//                         // Check if event date is before start date
//                         if (filterStart && eventDate < filterStart) {
//                             matchesDate = false;
//                         }
//                         // Check if event date is after end date
//                         if (filterEnd && eventDate > filterEnd) {
//                             matchesDate = false;
//                         }
//                     } else {
//                         // Hide events without specific dates if a date range is actively set
//                         matchesDate = false; 
//                     }
//                 }

//                 if (matchesSearch && matchesType && matchesAge && matchesDate) {
//                     container.style.display = 'block';
//                 } else {
//                     container.style.display = 'none';
//                 }
//             });
//         }

//         // --- GENERAL LOGIC ---
        
//         /**
//          * Decrements the seat count and updates the UI for a specific event.
//          */
//         function registerEvent(eventContainer) {
//             const eventId = eventContainer.getAttribute('data-event-id');
//             const seatsElement = document.getElementById(`${eventId}-seats`);
//             const registerButtons = eventContainer.querySelectorAll('.register-btn');
//             const t = translations[currentLang];
            
//             let seatsLeft = parseInt(eventContainer.getAttribute('data-seats'), 10);
            
//             if (seatsLeft > 0) {
//                 // Show temporary loading/registering state
//                 registerButtons.forEach(btn => {
//                     btn.textContent = 'Registering...'; 
//                     btn.disabled = true;
//                     btn.classList.remove('bg-green-500', 'hover:bg-green-600', 'transform', 'hover:scale-[1.03]');
//                     btn.classList.add('bg-blue-500', 'hover:bg-blue-600', 'cursor-default');
//                 });
                
//                 // Simulate network delay for registration
//                 setTimeout(() => {
//                     seatsLeft -= 1;
//                     eventContainer.setAttribute('data-seats', seatsLeft);
                    
//                     // Update the display text
//                     const seatsLabel = t[`${eventId}SeatsText`]; 
//                     if (seatsElement) {
//                         seatsElement.querySelector('.text-content').textContent = `${seatsLeft} ${seatsLabel}`;
//                     }
                    
//                     // Show confirmation message
//                     registerButtons.forEach(btn => {
//                         btn.textContent = t.registeredMsg;
//                     });

//                     setTimeout(() => {
//                         if (seatsLeft > 0) {
//                             // Reset to normal state
//                             registerButtons.forEach(btn => {
//                                 btn.textContent = t.registerBtn;
//                                 btn.disabled = false;
//                                 btn.classList.remove('bg-blue-500', 'hover:bg-blue-600', 'cursor-default');
//                                 btn.classList.add('bg-green-500', 'hover:bg-green-600', 'transform', 'hover:scale-[1.03]');
//                             });
//                         } else {
//                             // Sold Out state
//                             registerButtons.forEach(btn => {
//                                 btn.textContent = t.soldOutMsg;
//                                 btn.disabled = true;
//                                 btn.classList.remove('bg-green-500', 'hover:bg-green-600', 'transform', 'hover:scale-[1.03]', 'bg-blue-500', 'hover:bg-blue-600', 'cursor-default');
//                                 btn.classList.add('bg-red-500', 'opacity-70', 'cursor-not-allowed');
//                             });
//                         }
//                     }, 1000); // Confirmation visible for 1 second
//                 }, 500); // Registration delay
//             }
//         }


//         /**
//          * Handles navigation between different views with a smooth fade-and-slide animation.
//          */
//         function navigateTo(targetView) {
//             const allViews = document.querySelectorAll('.page-transition');
//             const targetViewElement = document.getElementById(`${targetView}-view`);
//             const navItems = document.querySelectorAll('.nav-item');
            
//             allViews.forEach(view => {
//                 view.classList.add('page-hidden');
//                 view.classList.remove('page-active');
//             });

//             navItems.forEach(item => {
//                 item.classList.remove('active');
//             });
            
//             targetViewElement.classList.add('page-hidden');
            
//             const activeNavItem = document.querySelector(`.nav-item[data-view="${targetView}"]`);
//             if (activeNavItem) {
//                 activeNavItem.classList.add('active');
//             }
            
//             // Force reflow to restart CSS animation
//             void targetViewElement.offsetWidth; 

//             targetViewElement.classList.remove('page-hidden');
//             targetViewElement.classList.add('page-active');

//             currentView = targetView;
//         }

//         /**
//          * Flips the event card to show either the front (details) or back (description).
//          */
//         function flipCard(cardElement, flip) {
//             if (flip) {
//                 cardElement.classList.add('flipped');
//             } else {
//                 cardElement.classList.remove('flipped');
//             }
//         }

//         // --- Date Input Handlers ---
//         function setupDateInputListeners() {
//             const startDateFilter = document.getElementById('startDateFilter');
//             const endDateFilter = document.getElementById('endDateFilter');
//             const dateMessage = document.getElementById('date-message');

//             startDateFilter.addEventListener('change', () => {
//                 endDateFilter.min = startDateFilter.value || '';
//                 dateMessage.textContent = '';
//             });

//             endDateFilter.addEventListener('change', () => {
//                 dateMessage.textContent = '';
//             });
//         }


//         // --- INITIALIZATION ---
//         document.addEventListener('DOMContentLoaded', () => {
//             // Initial content load (default to English)
//             updateContent(currentLang);
//             setupDateInputListeners();

//             // Initial sort and filter application (to display correctly on load)
//             filterEvents('', currentFilters);
//             sortEvents();
//             updateModalUI();


//             // --- Setup Navigation Listeners ---
//             document.querySelectorAll('.nav-item').forEach(link => {
//                 link.addEventListener('click', (e) => {
//                     e.preventDefault();
//                     const view = link.getAttribute('data-view');
//                     if (view) {
//                         navigateTo(view);
//                     }
//                 });
//             });

//             // --- Language Toggle Button Listener (for Home screen) ---
//             document.getElementById('language-toggle-btn').addEventListener('click', () => {
//                 const newLang = currentLang === 'en' ? 'ar' : 'en';
//                 updateContent(newLang);
//                 // Re-apply filters and sort to ensure correct visibility/order after language switch
//                 filterEvents(document.getElementById('event-search').value, currentFilters); 
//                 sortEvents();
//             });
            
//             // --- Events Search Listener (re-filters and re-sorts) ---
//             document.getElementById('event-search').addEventListener('input', (e) => {
//                 const searchTerm = e.target.value;
//                 currentFilters.search = searchTerm.trim().toLowerCase();
//                 filterEvents(searchTerm, currentFilters);
//                 sortEvents();
//             });

//             // --- Sort Select Listener ---
//             document.getElementById('sort-select').addEventListener('change', (e) => {
//                 currentFilters.sortBy = e.target.value;
//                 sortEvents(); // Just re-sort the currently visible (filtered) list
//             });
            
//             // --- Filter Modal Listeners ---
//             document.getElementById('filter-btn').addEventListener('click', () => toggleFilterModal(true));
//             document.getElementById('close-modal-btn').addEventListener('click', () => toggleFilterModal(false));
//             document.getElementById('apply-filters-btn').addEventListener('click', applyFilters);
//             document.getElementById('reset-filters-btn').addEventListener('click', resetFilters);
            
//             // Clicking outside modal content also closes it (optional)
//             document.getElementById('filter-modal-overlay').addEventListener('click', (e) => {
//                 if (e.target.id === 'filter-modal-overlay') {
//                     toggleFilterModal(false);
//                 }
//             });

//             // --- Card Flip Listeners ---
//             document.querySelectorAll('.see-more-btn').forEach(btn => {
//                 btn.addEventListener('click', (e) => {
//                     e.preventDefault();
//                     const card = e.target.closest('.event-card');
//                     if (card) {
//                         flipCard(card, true);
//                     }
//                 });
//             });
//             document.querySelectorAll('.see-less-btn').forEach(btn => {
//                 btn.addEventListener('click', (e) => {
//                     e.preventDefault();
//                     const card = e.target.closest('.event-card');
//                     if (card) {
//                         flipCard(card, false);
//                     }
//                 });
//             });
            
//             // --- Registration Listeners (Front and Back buttons) ---
//             document.querySelectorAll('.event-card-container').forEach(container => {
//                 container.querySelectorAll('.register-btn').forEach(btn => {
//                     btn.addEventListener('click', (e) => {
//                         e.preventDefault();
//                         if (!btn.disabled) {
//                             registerEvent(container);
//                         }
//                     });
//                 });
//             });


//             // Ensure initial view is Events
//             navigateTo('events');
//         });
//     </script>
// </body>
// </html>
