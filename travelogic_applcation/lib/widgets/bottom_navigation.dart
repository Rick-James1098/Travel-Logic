import 'package:flutter/material.dart';
import '../screens/travel_app.dart';

class CustomBottomNavigation extends StatelessWidget {
  final TabType activeTab;
  final Function(TabType) onTabChange;

  const CustomBottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                context,
                TabType.all,
                Icons.home,
                '전체',
              ),
              _buildTabItem(
                context,
                TabType.destination,
                Icons.location_on,
                '숙소',
              ),
              _buildTabItem(
                context,
                TabType.transport,
                Icons.directions_car,
                '교통수단',
              ),
              _buildTabItem(
                context,
                TabType.activity,
                Icons.camera_alt,
                '액티비티',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    TabType tab,
    IconData icon,
    String label,
  ) {
    final isActive = activeTab == tab;
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () => onTabChange(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}