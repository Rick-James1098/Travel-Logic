import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_record_app/models/tab_type.dart';

import '../models/travel_record.dart';

class TotalAmountFooter extends StatelessWidget {
  final List<TravelRecord> records;
  final TabType? filterType;

  const TotalAmountFooter({
    super.key,
    required this.records,
    this.filterType,
  });

  String get filterLabel {
    switch (filterType) {
      case TabType.destination:
        return '숙소';
      case TabType.transport:
        return '교통수단';
      case TabType.activity:
        return '액티비티';
      case TabType.all:
      case null:
        return '전체';
    }
  }

  int get totalAmount {
    return records.fold(0, (sum, record) => sum + record.amount);
  }

  @override
  Widget build(BuildContext context) {
    if (totalAmount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$filterLabel 총 지출',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${NumberFormat(' #,###').format(totalAmount)}원',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}