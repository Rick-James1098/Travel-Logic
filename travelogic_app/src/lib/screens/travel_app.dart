import 'package:flutter/material.dart';
import 'package:travel_record_app/helpers/database_helper.dart';
import '../models/travel_record.dart';
import '../models/trip_plan.dart';
import '../widgets/filtered_timeline.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/detailed_add_record_modal.dart';
import '../widgets/travel_list_sidebar.dart';
import '../widgets/travel_top_tabs.dart';
import '../widgets/RecordDetailPage.dart'; // 새로 만든 상세 정보 모달 임포트
import 'package:travel_record_app/models/tab_type.dart';
import 'package:travel_record_app/screens/home_screen.dart';
import 'package:travel_record_app/screens/settings_screen.dart';

class TravelApp extends StatefulWidget {
  final int currentNavIndex;
  final TripPlan? tripPlan;
  final Function(TripPlan)? onTripSelected;

  const TravelApp({
    super.key,
    this.currentNavIndex = 0,
    required this.tripPlan,
    this.onTripSelected,
  });

  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  TabType _activeTab = TabType.all;
  bool _isAddModalOpen = false;
  bool _isSidebarOpen = false;
  bool _isSettingsOpen = false;
  late int _currentNavIndex;
  List<TravelRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.currentNavIndex;
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    if (widget.tripPlan == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final dbHelper = DatabaseHelper();
    final records = await dbHelper.getTravelRecords(widget.tripPlan!.id);
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  void _handleAddRecord(TravelRecord record) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTravelRecord(record);
    _loadRecords();
  }

  void _handleUpdateRecord(TravelRecord updatedRecord) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.updateTravelRecord(updatedRecord);
    _loadRecords();
  }

  void _handleRecordDelete(TravelRecord recordToDelete) async {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: const Text('삭제 확인'),
            content: Text("'${recordToDelete.title}' 기록을 정말로 삭제하시겠습니까?"),
            actions: [
              TextButton(
                child: const Text('취소'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              TextButton(
                child: const Text('삭제', style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  final dbHelper = DatabaseHelper();
                  await dbHelper.deleteTravelRecord(recordToDelete.id);
                  _loadRecords();
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
    );
  }


  void _handleRecordTap(TravelRecord record) {
    showDialog(
      context: context,
      builder: (context) {
        return RecordDetailModal(
          initialRecord: record,
          onClose: () => Navigator.of(context).pop(),
          onRecordUpdated: (updatedRecord) {
            _handleUpdateRecord(updatedRecord);
          },
        );
      },
    );
  }

  void _handleTabChange(TabType tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  void _handleMenuClick() {
    setState(() {
      _isSidebarOpen = true;
    });
  }

  void _handleSettingsClick() {
    setState(() {
      _isSettingsOpen = true;
    });
  }

  void _onMyTravelClick() {
    Navigator.of(context).pop();
  }

  void _onHomeClick() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _onSettingsClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create a sorted copy of the records to be displayed.
    final sortedRecords = List<TravelRecord>.from(_records);
    sortedRecords.sort((a, b) {
      try {
        final aDateTime = DateTime.parse('${a.date} ${a.time}');
        final bDateTime = DateTime.parse('${b.date} ${b.time}');
        return aDateTime.compareTo(bDateTime);
      } catch (e) {
        return 0; // If parsing fails, maintain original order.
      }
    });

    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          setState(() {
            _isAddModalOpen = true;
          });
        },
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: _currentNavIndex,
        onMyTravelClick: _onMyTravelClick,
        onHomeClick: _onHomeClick,
        onSettingsClick: _onSettingsClick,
      ),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header with trip title if available
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(onPressed: _handleMenuClick, icon: const Icon(Icons.menu)),
                      ),
                      Text(
                        widget.tripPlan?.title ?? '내 여행',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Top tabs
                TravelTopTabs(activeTab: _activeTab, onTabChange: _handleTabChange),

                // Content
                Expanded(
                  child: sortedRecords.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '일정을 기록해보세요!!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isAddModalOpen = true;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('새 일정 기록하기'),
                              ),
                            ],
                          ),
                        )
                      : FilteredTimeline(
                          records: sortedRecords, // Use the sorted list
                          filterType: _activeTab == TabType.all ? null : _activeTab,
                          onRecordTap: _handleRecordTap,
                          onRecordDelete: _handleRecordDelete,
                        ),
                ),
              ],
            ),
          ),

          // Add Record Modal
          if (_isAddModalOpen)
            DetailedAddRecordModal(
              onClose: () => setState(() => _isAddModalOpen = false),
              onSave: _handleAddRecord,
              tripPlanId: widget.tripPlan!.id,
            ),

          // Sidebar
          if (_isSidebarOpen)
            TravelListSidebar(
              activeTripId: widget.tripPlan?.id,
              onTripSelected: (trip) {
                // When a trip is selected, close the sidebar and call the callback
                setState(() {
                  _isSidebarOpen = false;
                });
                widget.onTripSelected?.call(trip);
              },
              onClose: () => setState(() => _isSidebarOpen = false),
              onAddTrip: () {
                Navigator.of(context).pop('add_trip');
              },
            ),
        ],
      ),
    );
  }
}