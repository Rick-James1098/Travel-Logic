import 'package:flutter/material.dart';
import '../models/travel_record.dart';
import '../widgets/mobile_header.dart';
import '../widgets/filtered_timeline.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/detailed_add_record_modal.dart';
import '../widgets/travel_list_sidebar.dart';

enum TabType { all, destination, transport, activity }

class TravelApp extends StatefulWidget {
  const TravelApp({super.key});

  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  TabType _activeTab = TabType.all;
  bool _isAddModalOpen = false;
  bool _isSidebarOpen = false;
  bool _isSettingsOpen = false;

  final List<TravelRecord> _records = [
    TravelRecord(
      id: '1',
      type: TravelRecordType.destination,
      title: '경복궁 방문',
      description: '조선 왕조의 정궁인 경복궁을 둘러보며 한국의 전통 문화를 체험했습니다. 근정전과 경회루가 특히 인상적이었어요.',
      location: '서울특별시 종로구',
      time: '09:30',
      date: '2025-01-19',
      amount: 3000,
    ),
    TravelRecord(
      id: '2',
      type: TravelRecordType.transport,
      title: '지하철 3호선',
      description: '경복궁역에서 안국역까지 지하철을 이용했습니다.',
      location: '경복궁역 → 안국역',
      time: '11:00',
      date: '2025-01-19',
      amount: 1600,
    ),
    TravelRecord(
      id: '3',
      type: TravelRecordType.activity,
      title: '북촌 한옥마을 탐방',
      description: '전통 한옥들이 잘 보존된 북촌 한옥마을을 걸으며 사진을 찍었습니다. 좁은 골목길 사이로 보이는 한옥들이 아름다웠어요.',
      location: '서울특별시 종로구 북촌로',
      time: '11:30',
      date: '2025-01-19',
      amount: 0,
    ),
    TravelRecord(
      id: '4',
      type: TravelRecordType.destination,
      title: '인사동 쇼핑',
      description: '전통 공예품과 차를 파는 상점들을 둘러보며 기념품을 구입했습니다.',
      location: '서울특별시 종로구 인사동',
      time: '14:00',
      date: '2025-01-19',
      amount: 25000,
    ),
  ];

  void _handleAddRecord(TravelRecord record) {
    setState(() {
      _records.add(record.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()));
    });
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
      bottomNavigationBar: CustomBottomNavigation(
        activeTab: _activeTab,
        onTabChange: _handleTabChange,
      ),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                MobileHeader(
                  onMenuClick: _handleMenuClick,
                  onSettingsClick: _handleSettingsClick,
                ),
                Expanded(
                  child: FilteredTimeline(
                    records: _records,
                    filterType: _activeTab == TabType.all ? null : _activeTab,
                  ),
                ),
              ],
            ),
          ),

          // Add Record Modal
          if (_isAddModalOpen)
            DetailedAddRecordModal(
              onClose: () {
                setState(() {
                  _isAddModalOpen = false;
                });
              },
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
                      const Text(
                        '설정',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '설정 기능은 곧 업데이트될 예정입니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isSettingsOpen = false;
                            });
                          },
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
            TravelListSidebar(
              onClose: () {
                setState(() {
                  _isSidebarOpen = false;
                });
              },
            ),
        ],
      ),
    );
  }
}