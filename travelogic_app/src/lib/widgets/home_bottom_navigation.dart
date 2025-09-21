import 'package:flutter/material.dart';

class HomeBottomNavigation extends StatelessWidget {
  final VoidCallback onMyTravelClick;
  final VoidCallback onHomeClick;
  final VoidCallback onSettingsClick;
  final int currentIndex;

  const HomeBottomNavigation({
    super.key,
    required this.onMyTravelClick,
    required this.onHomeClick,
    required this.onSettingsClick,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context,
              icon: Icons.map_outlined,
              selectedIcon: Icons.map,
              label: '내 여행',
              isSelected: currentIndex == 0,
              onTap: onMyTravelClick,
            ),
            _buildNavItem(
              context,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: '홈',
              isSelected: currentIndex == 1,
              onTap: onHomeClick,
            ),
            _buildNavItem(
              context,
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              label: '설정',
              isSelected: currentIndex == 2,
              onTap: onSettingsClick,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: 24,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}