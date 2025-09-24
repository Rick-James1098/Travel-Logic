import 'package:flutter/material.dart';
import '../models/trip_plan.dart';
import '../models/trip_event.dart';
import '../widgets/home_header.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/trip_edit_modal.dart';
import 'travel_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 1; // Home is selected by default
  bool _isEditModalOpen = false;
  TripPlan? _editingTrip;

  List<TripPlan> _upcomingTrips = [
    TripPlan(
      id: '1',
      title: '제주도 여행',
      destination: '제주특별자치도',
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 8)),
      imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43',
      description: '한라산 등반과 해변 여행을 즐기는 3박 4일 여행',
      estimatedBudget: 450000,
      events: [
        TripEvent(title: '한라산 등반', date: DateTime.now().add(const Duration(days: 6)), description: '성판악 코스'),
        TripEvent(title: '해변에서 휴식', date: DateTime.now().add(const Duration(days: 7)), description: '협재 해수욕장'),
      ],
    ),
    TripPlan(
      id: '2',
      title: '부산 맛집 투어',
      destination: '부산광역시',
      startDate: DateTime.now().add(const Duration(days: 12)),
      endDate: DateTime.now().add(const Duration(days: 14)),
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
      description: '해운대와 감천문화마을을 둘러보는 맛집 투어',
      estimatedBudget: 280000,
      events: [
        TripEvent(title: '돼지국밥 맛집', date: DateTime.now().add(const Duration(days: 12)), description: '쌍둥이돼지국밥'),
        TripEvent(title: '감천문화마을', date: DateTime.now().add(const Duration(days: 13)), description: '사진 찍기 좋은 곳'),
      ],
    ),
  ];

  List<TripEvent> _getSortedUpcomingEvents() {
    final allEvents = _upcomingTrips.expand((trip) => trip.events).toList();
    allEvents.sort((a, b) => a.date.compareTo(b.date));
    return allEvents;
  }

  @override
  void dispose() {
    // _pageController.dispose(); // No longer needed
    super.dispose();
  }

  void _navigateToMyTravel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TravelApp(
          currentNavIndex: 0,
          onNavChange: (index) {
            if (index == 1) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  /*void _editTrip(TripPlan trip) {
    setState(() {
      _editingTrip = trip;
      _isEditModalOpen = true;
    });
  }*/

  void _handleSaveTrip(TripPlan trip) {
    setState(() {
      if (_editingTrip != null) {
        // Edit existing trip
        final index = _upcomingTrips.indexWhere((t) => t.id == trip.id);
        if (index != -1) {
          _upcomingTrips[index] = trip;
        }
      } else {
        // Add new trip
        _upcomingTrips.add(trip);
      }
      // Sort trips by start date
      _upcomingTrips.sort((a, b) => a.startDate.compareTo(b.startDate));
    });
  }

  void _handleDeleteTrip() {
    if (_editingTrip != null) {
      setState(() {
        _upcomingTrips.removeWhere((t) => t.id == _editingTrip!.id);
      });
    }
  }

  void _onHomeClick() {
    setState(() {
      _currentNavIndex = 1;
    });
  }

  void _onSettingsClick() {
    setState(() {
      _currentNavIndex = 2;
    });
    // TODO: Navigate to settings page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('설정 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onProfileClick() {
    setState(() {
      _currentNavIndex = 3;
    });
    // TODO: Navigate to profile page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('프로필 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onNotificationClick() {
    setState(() {
      _currentNavIndex = 4;
    });
    // TODO: Navigate to notifications page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('알림 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = _getSortedUpcomingEvents();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      
      // Bottom Navigation
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: _currentNavIndex,
        onMyTravelClick: () {
          setState(() {
            _currentNavIndex = 0;
          });
          _navigateToMyTravel();
        },
        onHomeClick: _onHomeClick,
        onSettingsClick: _onSettingsClick,
      ),

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                HomeHeader(
                  onProfileClick: _onProfileClick,
                  onNotificationClick: _onNotificationClick,
                ),
                
                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안녕하세요! 👋',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '다가오는 일정을 확인해보세요',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Upcoming events section
                      if (upcomingEvents.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '다가오는 일정',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Vertical event list
                        Expanded(
                          child: ListView.builder(
                            itemCount: upcomingEvents.length,
                            itemBuilder: (context, index) {
                              final event = upcomingEvents[index];
                              return _UpcomingEventCard(event: event);
                            },
                          ),
                        ),
                      ] else ...[
                        // Empty state
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '예정된 일정이 없습니다',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '새로운 여행을 계획해보세요!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Edit Modal
          if (_isEditModalOpen)
            TripEditModal(
              trip: _editingTrip,
              onClose: () {
                setState(() {
                  _isEditModalOpen = false;
                });
              },
              onSave: _handleSaveTrip,
              onDelete: _editingTrip != null ? _handleDeleteTrip : null,
            ),
        ],
      ),
    );
  }
}

class _UpcomingEventCard extends StatelessWidget {
  final TripEvent event;

  const _UpcomingEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${event.date.year}년 ${event.date.month}월 ${event.date.day}일',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(event.description),
          ],
        ),
      ),
    );
  }
}
