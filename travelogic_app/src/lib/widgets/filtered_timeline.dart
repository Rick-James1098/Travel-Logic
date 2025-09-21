import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_record_app/models/tab_type.dart';

import '../models/travel_record.dart';
import 'record_card.dart';
import 'total_amount_footer.dart';


class FilteredTimeline extends StatelessWidget {
  final List<TravelRecord> records;
  final TabType? filterType;

  const FilteredTimeline({
    super.key,
    required this.records,
    this.filterType,
  });

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

    // Sort records within each date by time
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
            Icon(
              Icons.travel_explore,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '여행 기록이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
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
                  ...dayRecords.map((record) => RecordCard(record: record)),
                  
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