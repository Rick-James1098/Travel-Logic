import 'package:flutter/material.dart';
import '../models/travel_record.dart';
import '../models/trip_plan.dart';
import '../widgets/mobile_header.dart';
import '../widgets/filtered_timeline.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/detailed_add_record_modal.dart';
import '../widgets/travel_list_sidebar.dart';
import '../widgets/travel_top_tabs.dart';
// import '../widgets/RecordDetailPage.dart'; // 더 이상 사용하지 않음
import '../widgets/RecordDetailPage.dart'; // 새로 만든 상세 정보 모달 임포트
import 'package:travel_record_app/models/tab_type.dart';

class TravelApp extends StatefulWidget {
  final int currentNavIndex;
  final TripPlan? tripPlan;
  final Function(int)? onNavChange;

  const TravelApp({
    super.key,
    this.currentNavIndex = 0,
    this.tripPlan,
    this.onNavChange,
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

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.currentNavIndex;
  }

  // 샘플 데이터 (기존과 동일)
  final List<TravelRecord> _records = [
    TravelRecord(id: '1', type: TravelRecordType.destination, title: '경복궁 방문', description: '조선 왕조의 정궁인 경복궁을 둘러보며 한국의 전통 문화를 체험했습니다. 근정전과 경회루가 특히 인상적이었어요.', location: '서울특별시 종로구', time: '09:30', date: '2025-01-19', amount: 3000,),
    TravelRecord(id: '2', type: TravelRecordType.transport, title: '지하철 3호선', description: '경복궁역에서 안국역까지 지하철을 이용했습니다.', location: '경복궁역 → 안국역', time: '11:00', date: '2025-01-19', amount: 1600,),
    TravelRecord(id: '3', type: TravelRecordType.activity, title: '북촌 한옥마을 탐방', description: '전통 한옥들이 잘 보존된 북촌 한옥마을을 걸으며 사진을 찍었습니다. 좁은 골목길 사이로 보이는 한옥들이 아름다웠어요.', location: '서울특별시 종로구 북촌로', time: '11:30', date: '2025-01-19', amount: 0,),
    TravelRecord(id: '4', type: TravelRecordType.destination, title: '인사동 쇼핑', description: '전통 공예품과 차를 파는 상점들을 둘러보며 기념품을 구입했습니다.', location: '서울특별시 종로구 인사동', time: '14:00', date: '2025-01-19', amount: 25000,),
  ];

  void _handleAddRecord(TravelRecord record) {
    setState(() {
      _records.add(record.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()));
    });
  }

  void _handleUpdateRecord(TravelRecord updatedRecord) {
    setState(() {
      final index = _records.indexWhere((r) => r.id == updatedRecord.id);
      if (index != -1) {
        _records[index] = updatedRecord;
      }
    });
  }

  // --- ⬇️ 이 부분이 수정되었습니다 ⬇️ ---
  // 레코드 카드를 탭했을 때, 페이지 이동 대신 상세 정보 모달을 띄웁니다.
  void _handleRecordTap(TravelRecord record) {
    showDialog(
      context: context,
      builder: (context) {
        // 이전에 만든 RecordDetailModal 위젯을 여기서 사용합니다.
        return RecordDetailModal(
          initialRecord: record,
          onClose: () => Navigator.of(context).pop(),
          // 모달 안에서 수정이 일어나면, _handleUpdateRecord 함수를 호출해
          // 메인 리스트의 데이터를 실시간으로 업데이트합니다.
          onRecordUpdated: _handleUpdateRecord,
        );
      },
    );
  }
  // --- ⬆️ 여기까지 수정되었습니다 ⬆️ ---

  void _handleRecordDelete(TravelRecord recordToDelete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('삭제 확인'),
        content: Text("'${recordToDelete.title}' 기록을 정말로 삭제하시겠습니까?"),
        actions: [
          TextButton(
            child: const Text('취소'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                _records.removeWhere((record) => record.id == recordToDelete.id);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // 기존의 다른 핸들러 함수들은 그대로 유지
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
    setState(() {
      _currentNavIndex = 0;
    });
  }

  void _onHomeClick() {
    setState(() {
      _currentNavIndex = 1;
    });
    widget.onNavChange?.call(1);
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

  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    children: [
                      IconButton(onPressed: _handleMenuClick, icon: const Icon(Icons.menu)),
                      Expanded(
                        child: Text(
                          widget.tripPlan?.title ?? '내 여행',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(onPressed: _handleSettingsClick, icon: const Icon(Icons.settings)),
                    ],
                  ),
                ),

                // Top tabs
                TravelTopTabs(activeTab: _activeTab, onTabChange: _handleTabChange),

                // Content
                Expanded(
                  child: FilteredTimeline(
                    records: _records,
                    filterType: _activeTab == TabType.all ? null : _activeTab,
                    // 수정된 _handleRecordTap 함수를 FilteredTimeline 위젯에 전달합니다.
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
            ),

          // Settings Modal
          if (_isSettingsOpen)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('설정', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      Text('설정 기능은 곧 업데이트될 예정입니다.', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _isSettingsOpen = false),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text('닫기'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Sidebar
          if (_isSidebarOpen)
            TravelListSidebar(onClose: () => setState(() => _isSidebarOpen = false)),
        ],
      ),
    );
  }
}