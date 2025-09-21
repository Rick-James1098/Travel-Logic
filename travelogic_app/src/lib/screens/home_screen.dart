import 'package:flutter/material.dart';
import '../models/trip_plan.dart';
import '../widgets/home_header.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/upcoming_trip_card.dart';
import '../widgets/trip_edit_modal.dart';
import 'travel_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
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
    ),
    TripPlan(
      id: '3',
      title: '경주 역사탐방',
      destination: '경상북도 경주시',
      startDate: DateTime.now().add(const Duration(days: 20)),
      endDate: DateTime.now().add(const Duration(days: 22)),
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
      description: '불국사와 석굴암, 첨성대를 둘러보는 역사 여행',
      estimatedBudget: 320000,
    ),
    TripPlan(
      id: '4',
      title: '강릉 바다 여행',
      destination: '강원도 강릉시',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 32)),
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
      description: '정동진 해변과 오죽헌을 즐기는 바다 여행',
      estimatedBudget: 380000,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
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

  void _addNewTrip() {
    setState(() {
      _editingTrip = null;
      _isEditModalOpen = true;
    });
  }

  void _editTrip(TripPlan trip) {
    setState(() {
      _editingTrip = trip;
      _isEditModalOpen = true;
    });
  }

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
    // TODO: Navigate to profile page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('프로필 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onNotificationClick() {
    // TODO: Navigate to notifications page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('알림 페이지는 곧 업데이트될 예정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onTripCardTap(TripPlan trip) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TravelApp(
          currentNavIndex: 0,
          tripPlan: trip,
          onNavChange: (index) {
            if (index == 1) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  void _onTripCardLongPress(TripPlan trip) {
    _editTrip(trip);
  }

  @override
  Widget build(BuildContext context) {
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
      
      // Floating Action Button for adding new trip
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTrip,
        child: const Icon(Icons.add),
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
                              '다가오는 여행을 확인해보세요',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Trip cards section
                      if (_upcomingTrips.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '다가오는 여행',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Horizontal trip cards
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _upcomingTrips.length,
                            itemBuilder: (context, index) {
                              final trip = _upcomingTrips[index];
                              return UpcomingTripCard(
                                trip: trip,
                                onTap: () => _onTripCardTap(trip),
                                onLongPress: () => _onTripCardLongPress(trip),
                              );
                            },
                          ),
                        ),
                        
                        // Page indicator
                        if (_upcomingTrips.length > 1) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _upcomingTrips.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ] else ...[
                        // Empty state
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.flight_takeoff,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '예정된 여행이 없습��다',
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