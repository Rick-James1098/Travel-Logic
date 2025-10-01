import 'travel_record.dart';

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
  final List<TravelRecord> records;

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
    this.records = const [],
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
    List<TravelRecord>? records,
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
      records: records ?? this.records,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'imageUrl': imageUrl,
      'description': description,
      'estimatedBudget': estimatedBudget,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TripPlan.fromMap(Map<String, dynamic> map) {
    return TripPlan(
      id: map['id'],
      title: map['title'],
      destination: map['destination'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      imageUrl: map['imageUrl'],
      description: map['description'],
      estimatedBudget: map['estimatedBudget'],
      isCompleted: map['isCompleted'] == 1,
      records: [], // Records should be loaded separately
    );
  }
}