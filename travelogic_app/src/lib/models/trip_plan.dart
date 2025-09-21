import 'trip_event.dart';

class TripPlan {
  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final String description;
  final int estimatedBudget;
  final bool isCompleted;
  final List<TripEvent> events;

  TripPlan({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.description,
    required this.estimatedBudget,
    this.isCompleted = false,
    this.events = const [],
  });

  TripPlan copyWith({
    String? id,
    String? title,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    String? imageUrl,
    String? description,
    int? estimatedBudget,
    bool? isCompleted,
    List<TripEvent>? events,
  }) {
    return TripPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      isCompleted: isCompleted ?? this.isCompleted,
      events: events ?? this.events,
    );
  }

  int get daysUntilTrip {
    final now = DateTime.now();
    if (startDate.isBefore(now)) return 0;
    return startDate.difference(now).inDays;
  }

  int get tripDuration {
    return endDate.difference(startDate).inDays + 1;
  }
}