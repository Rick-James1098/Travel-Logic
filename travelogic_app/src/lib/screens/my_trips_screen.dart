
import 'package:flutter/material.dart';
import '../models/trip_plan.dart';
import '../widgets/upcoming_trip_card.dart';

class MyTripsScreen extends StatelessWidget {
  final List<TripPlan> upcomingTrips;
  final bool isLoading;
  final Function(TripPlan) onTripSelected;
  final Function(TripPlan) onTripDelete;
  final VoidCallback onAddTrip;

  const MyTripsScreen({
    super.key,
    required this.upcomingTrips,
    required this.isLoading,
    required this.onTripSelected,
    required this.onTripDelete,
    required this.onAddTrip,
  });

  void _showDeleteConfirmation(BuildContext context, TripPlan trip) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('여행 삭제'),
          content: Text("'${trip.title}' 여행을 정말로 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
              onPressed: () {
                onTripDelete(trip);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 여행 목록'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                        onLongPress: () => _showDeleteConfirmation(context, trip),
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
