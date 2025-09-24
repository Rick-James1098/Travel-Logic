import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_record_app/models/tab_type.dart'; // 실제 경로에 맞게 수정

import '../models/travel_record.dart'; // 실제 경로에 맞게 수정
import 'record_card.dart';
import 'total_amount_footer.dart';


class FilteredTimeline extends StatelessWidget {
  final List<TravelRecord> records;
  final TabType? filterType;
  final Function(TravelRecord) onRecordTap;      // ✨ 1. 탭 콜백 함수 추가
  final Function(TravelRecord) onRecordDelete;   // ✨ 2. 삭제 콜백 함수 추가

  const FilteredTimeline({
    super.key,
    required this.records,
    this.filterType,
    required this.onRecordTap,      // ✨ 3. 생성자에 콜백 함수를 필수로 받도록 수정
    required this.onRecordDelete,
  });

  // get filteredRecords, get groupedRecords 는 기존과 동일합니다.
  List<TravelRecord> get filteredRecords {
    if (filterType == null) return records;

    switch (filterType!) {
      case TabType.all:
        return records;
      case TabType.destination:
        return records.where((r) => r.type == TravelRecordType.destination).toList();
      case TabType.transport:
        return records.where((r) => r.type == TravelRecordType.transport).toList();
      case TabType.activity:
        return records.where((r) => r.type == TravelRecordType.activity).toList();
    }
  }

  Map<String, List<TravelRecord>> get groupedRecords {
    final Map<String, List<TravelRecord>> grouped = {};

    for (final record in filteredRecords) {
      if (!grouped.containsKey(record.date)) {
        grouped[record.date] = [];
      }
      grouped[record.date]!.add(record);
    }

    for (final dayRecords in grouped.values) {
      dayRecords.sort((a, b) => a.time.compareTo(b.time));
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (filteredRecords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.travel_explore, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('여행 기록이 없습니다', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedRecords.length,
            itemBuilder: (context, index) {
              final date = groupedRecords.keys.elementAt(index);
              final dayRecords = groupedRecords[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _formatDate(date),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Records for this date
                  // ✨ 4. map 안에서 RecordCard를 생성할 때 콜백 함수들을 전달합니다.
                  ...dayRecords.map((record) => RecordCard(
                    record: record,
                    onTap: () => onRecordTap(record),
                    onDelete: () => onRecordDelete(record),
                  )),

                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
        TotalAmountFooter(
          records: filteredRecords,
          filterType: filterType,
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
    } catch (e) {
      return dateString;
    }
  }
}