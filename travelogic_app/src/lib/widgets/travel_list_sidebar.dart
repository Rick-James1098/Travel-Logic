import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip_plan.dart';

class TravelListSidebar extends StatelessWidget {
  final VoidCallback onClose;
  final List<TripPlan> trips;
  final TripPlan? activeTrip;
  final Function(TripPlan) onTripSelected;

  const TravelListSidebar({
    super.key,
    required this.onClose,
    required this.trips,
    this.activeTrip,
    required this.onTripSelected,
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
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          final bool isActive = activeTrip?.id == trip.id;
                          return _buildTravelItem(
                            context,
                            trip,
                            isActive,
                          );
                        },
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
    TripPlan trip,
    bool isActive,
  ) {
    final DateFormat formatter = DateFormat('yyyy.MM.dd');
    final String dateRange = '${formatter.format(trip.startDate)} - ${formatter.format(trip.endDate)}';
    
    // A simple way to get an icon from the destination
    IconData icon = Icons.location_city;
    if (trip.destination.contains('해변') || trip.destination.contains('바다')) {
      icon = Icons.beach_access;
    } else if (trip.destination.contains('산') || trip.destination.contains('제주')) {
      icon = Icons.landscape;
    }

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
          trip.title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          dateRange,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: () {
          onTripSelected(trip);
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