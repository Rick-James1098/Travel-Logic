import 'package:flutter/material.dart';

class TravelListSidebar extends StatelessWidget {
  final VoidCallback onClose;

  const TravelListSidebar({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black54,
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping on sidebar
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '여행 목록',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: onClose,
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),

                    // Travel List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildTravelItem(
                            context,
                            '서울 여행',
                            '2025.01.19 - 2025.01.20',
                            Icons.location_city,
                            true,
                          ),
                          _buildTravelItem(
                            context,
                            '부산 여행',
                            '2025.01.10 - 2025.01.12',
                            Icons.beach_access,
                            false,
                          ),
                          _buildTravelItem(
                            context,
                            '제주도 여행',
                            '2024.12.24 - 2024.12.27',
                            Icons.landscape,
                            false,
                          ),
                        ],
                      ),
                    ),

                    // Add New Travel Button
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Add new travel logic
                            onClose();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('새 여행 추가'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTravelItem(
    BuildContext context,
    String title,
    String date,
    IconData icon,
    bool isActive,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: () {
          // Switch travel logic
          onClose();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: isActive
            ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
            : null,
      ),
    );
  }
}