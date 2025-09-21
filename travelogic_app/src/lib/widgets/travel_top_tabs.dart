import 'package:flutter/material.dart';
import 'package:travel_record_app/models/tab_type.dart';

class TravelTopTabs extends StatelessWidget {
  final TabType activeTab;
  final Function(TabType) onTabChange;

  const TravelTopTabs({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab(context, TabType.all, '전체', Icons.list),
          const SizedBox(width: 8),
          _buildTab(context, TabType.destination, '숙소', Icons.location_on),
          const SizedBox(width: 8),
          _buildTab(context, TabType.transport, '교통', Icons.directions_car),
          const SizedBox(width: 8),
          _buildTab(context, TabType.activity, '액티비티', Icons.camera_alt),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, TabType tab, String label, IconData icon) {
    final isActive = activeTab == tab;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChange(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isActive 
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}