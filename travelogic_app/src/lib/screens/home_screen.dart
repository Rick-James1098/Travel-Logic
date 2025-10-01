import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:travel_record_app/helpers/database_helper.dart';
import '../models/travel_record.dart';
import '../models/trip_plan.dart';
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
  List<TripPlan> _upcomingTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() {
      _isLoading = true;
    });
    final dbHelper = DatabaseHelper();
    final tripPlans = await dbHelper.getTripPlans();
    List<TripPlan> tripsWithRecords = [];

    for (var trip in tripPlans) {
      final records = await dbHelper.getTravelRecords(trip.id);
      tripsWithRecords.add(trip.copyWith(records: records));
    }

    setState(() {
      _upcomingTrips = tripsWithRecords;
      _upcomingTrips.sort((a, b) => a.startDate.compareTo(b.startDate));
      _isLoading = false;
    });
  }


  List<TravelRecord> _getSortedUpcomingRecords() {
    final allRecords = _upcomingTrips.expand((trip) => trip.records).toList();
    final now = DateTime.now();

    final upcomingRecords = allRecords.where((record) {
      try {
        final recordDateTime = DateTime.parse('${record.date} ${record.time}');
        return recordDateTime.isAfter(now);
      } catch (e) {
        return false;
      }
    }).toList();

    upcomingRecords.sort((a, b) {
      try {
        final aDateTime = DateTime.parse('${a.date} ${a.time}');
        final bDateTime = DateTime.parse('${b.date} ${b.time}');
        return aDateTime.compareTo(bDateTime);
      } catch (e) {
        return 0;
      }
    });

    return upcomingRecords;
  }

  @override
  void dispose() {
    // _pageController.dispose(); // No longer needed
    super.dispose();
  }

  void _handleTripSelected(TripPlan trip) {
    // This function is now only for handling selection from the sidebar inside TravelApp
    setState(() {
      // _activeTrip = trip; // No longer needed here, TravelApp will manage its own active trip
    });
    Navigator.of(context).pop(); // Pop the current TravelApp
    _navigateToMyTravel(selectedTrip: trip); // Push new one
  }

  void _navigateToMyTravel({TripPlan? selectedTrip}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TravelApp(
          currentNavIndex: 0, // Keep this as 0 for 'My Travel'
          tripPlan: selectedTrip, // Pass only the selected trip
          onTripSelected: _handleTripSelected,
        ),
      ),
    );

    if (result == 'add_trip') {
      _addTrip();
    } else {
      _loadTrips(); // Reload trips after returning from TravelApp
    }
  }

  

  // Function to handle adding a new trip
  void _addTrip() {
    setState(() {
      _editingTrip = null; // Ensure we are adding, not editing
      _isEditModalOpen = true;
    });
  }

  void _handleSaveTrip(TripPlan trip) async {
    final dbHelper = DatabaseHelper();
    if (_editingTrip != null) {
      await dbHelper.updateTripPlan(trip);
    } else {
      await dbHelper.insertTripPlan(trip);
    }
    _loadTrips(); // Reload trips after saving
    setState(() {
      _isEditModalOpen = false; // Close modal on save
    });
  }

  void _handleDeleteTrip(TripPlan trip) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTripPlan(trip.id);
    _loadTrips(); // Reload trips after deleting
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
    final upcomingRecords = _getSortedUpcomingRecords();
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
              if (upcomingRecords.isNotEmpty) ...[
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
                    itemCount: upcomingRecords.length,
                    itemBuilder: (context, index) {
                      final record = upcomingRecords[index];
                      return _UpcomingRecordCard(record: record);
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
                  isLoading: _isLoading,
                  onTripSelected: (trip) {
                    // When a trip is selected, navigate to the detailed view
                    _navigateToMyTravel(selectedTrip: trip);
                  },
                  onTripDelete: _handleDeleteTrip, // Pass the delete trip function
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
            ),
        ],
      ),
    );
  }
}

class _UpcomingRecordCard extends StatelessWidget {
  final TravelRecord record;

  const _UpcomingRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final recordDateTime = DateTime.parse('${record.date} ${record.time}');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${recordDateTime.year}년 ${recordDateTime.month}월 ${recordDateTime.day}일 ${recordDateTime.hour.toString().padLeft(2, '0')}:${recordDateTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(record.description),
          ],
        ),
      ),
    );
  }
}


