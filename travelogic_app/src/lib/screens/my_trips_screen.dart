
import 'package:flutter/material.dart';
import '../models/trip_plan.dart';
import '../widgets/upcoming_trip_card.dart';

class MyTripsScreen extends StatelessWidget {
  final List<TripPlan> upcomingTrips;
  final Function(TripPlan) onTripSelected;
  final VoidCallback onAddTrip;

  const MyTripsScreen({
    super.key,
    required this.upcomingTrips,
    required this.onTripSelected,
    required this.onAddTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 여행 목록'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: upcomingTrips.length,
              itemBuilder: (context, index) {
                final trip = upcomingTrips[index];
                return UpcomingTripCard(
                  trip: trip,
                  onTap: () => onTripSelected(trip),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: onAddTrip,
              icon: const Icon(Icons.add),
              label: const Text('새 여행 계획하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
