import 'package:flutter/material.dart';
import '../models/travel_record.dart';
import '../models/trip_plan.dart';
import '../models/trip_event.dart';
import '../widgets/home_header.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/trip_edit_modal.dart';
import 'travel_app.dart';
import 'my_trips_screen.dart'; // Import the new screen
import 'settings_screen.dart'; // Import the new settings screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 1; // Home is selected by default
  bool _isEditModalOpen = false;
  TripPlan? _editingTrip;
  TripPlan? _activeTrip;

  @override
  void initState() {
    super.initState();
    if (_upcomingTrips.isNotEmpty) {
      _activeTrip = _upcomingTrips.first;
    }
  }

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
      records: [
        TravelRecord(id: 'rec1', type: TravelRecordType.transport, title: '흑돼지 전문', description: '제주 흑돼지 맛집에서 저녁 식사', location: '서귀포시', time: '19:00', date: '2025-09-29', amount: 85000,),
        TravelRecord(id: 'rec2', type: TravelRecordType.destination, title: '오션뷰 호텔', description: '해변가에 위치한 호텔에서 1박', location: '제주시', time: '15:00', date: '2025-09-29', amount: 220000,),
      ]
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
      records: [
        TravelRecord(id: 'rec3', type: TravelRecordType.destination, title: '돼지국밥', description: '유명한 돼지국밥집 방문', location: '부산진구', time: '12:30', date: '2025-10-06', amount: 12000,),
        TravelRecord(id: 'rec4', type: TravelRecordType.activity, title: '해운대 해수욕장', description: '해변 산책 및 구경', location: '해운대구', time: '16:00', date: '2025-10-06', amount: 0,),
        TravelRecord(id: 'rec5', type: TravelRecordType.transport, title: '씨앗호떡', description: '남포동 명물 씨앗호떡', location: '중구 남포동', time: '18:00', date: '2025-10-06', amount: 2000,),
      ]
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

  void _handleTripSelected(TripPlan trip) {
    // This function is now only for handling selection from the sidebar inside TravelApp
    setState(() {
      _activeTrip = trip;
    });
    Navigator.of(context).pop(); // Pop the current TravelApp
    _navigateToMyTravel(selectedTrip: trip); // Push new one
  }

  void _navigateToMyTravel({TripPlan? selectedTrip}) async {
    final tripToShow = selectedTrip ?? _activeTrip;
    if (tripToShow == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('표시할 여행 계획이 없습니다.')),
      );
      return;
    }

    final updatedRecords = await Navigator.of(context).push<List<TravelRecord>>(
      MaterialPageRoute(
        builder: (context) => TravelApp(
          currentNavIndex: 0, // Keep this as 0 for 'My Travel'
          tripPlans: _upcomingTrips,
          tripPlan: tripToShow,
          activeTripId: tripToShow.id,
          onTripSelected: _handleTripSelected,
        ),
      ),
    );

    if (updatedRecords != null) {
      setState(() {
        final tripIndex = _upcomingTrips.indexWhere((t) => t.id == tripToShow.id);
        if (tripIndex != -1) {
          _upcomingTrips[tripIndex] = _upcomingTrips[tripIndex].copyWith(records: updatedRecords);
          if (_activeTrip?.id == tripToShow.id) {
            _activeTrip = _upcomingTrips[tripIndex];
          }
        }
      });
    }
  }

  void _editTrip(TripPlan trip) {
    setState(() {
      _editingTrip = trip;
      _isEditModalOpen = true;
    });
  }

  // Function to handle adding a new trip
  void _addTrip() {
    setState(() {
      _editingTrip = null; // Ensure we are adding, not editing
      _isEditModalOpen = true;
    });
  }

  void _handleSaveTrip(TripPlan trip) {
    setState(() {
      if (_editingTrip != null) {
        final index = _upcomingTrips.indexWhere((t) => t.id == trip.id);
        if (index != -1) {
          _upcomingTrips[index] = trip;
        }
      } else {
        _upcomingTrips.add(trip);
      }
      _upcomingTrips.sort((a, b) => a.startDate.compareTo(b.startDate));
      _isEditModalOpen = false; // Close modal on save
    });
  }

  void _handleDeleteTrip() {
    if (_editingTrip != null) {
      setState(() {
        _upcomingTrips.removeWhere((t) => t.id == _editingTrip!.id);
        _isEditModalOpen = false; // Close modal on delete
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('설정 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onProfileClick() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('프로필 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onNotificationClick() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('알림 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildMainContent() {
    final upcomingEvents = _getSortedUpcomingEvents();
    return Column(
      children: [
        HomeHeader(
          onProfileClick: _onProfileClick,
          onNotificationClick: _onNotificationClick,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: _currentNavIndex,
        onMyTravelClick: () {
          setState(() {
            _currentNavIndex = 0;
          });
        },
        onHomeClick: _onHomeClick,
        onSettingsClick: _onSettingsClick,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentNavIndex,
              children: [
                // My Trips Screen (Index 0)
                MyTripsScreen(
                  upcomingTrips: _upcomingTrips,
                  onTripSelected: (trip) {
                    // When a trip is selected, navigate to the detailed view
                    _navigateToMyTravel(selectedTrip: trip);
                  },
                  onAddTrip: _addTrip, // Pass the add trip function
                ),
                // Home Screen (Index 1)
                _buildMainContent(),
                // Settings Screen (Index 2) - Placeholder
                const SettingsScreen(),
              ],
            ),
          ),
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


