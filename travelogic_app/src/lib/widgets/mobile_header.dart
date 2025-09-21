import 'package:flutter/material.dart';

class MobileHeader extends StatelessWidget {
  final VoidCallback onMenuClick;
  final VoidCallback onSettingsClick;

  const MobileHeader({
    super.key,
    required this.onMenuClick,
    required this.onSettingsClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onMenuClick,
            icon: const Icon(Icons.menu),
            iconSize: 24,
          ),
          const Text(
            '여행 기록',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: onSettingsClick,
            icon: const Icon(Icons.settings),
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}