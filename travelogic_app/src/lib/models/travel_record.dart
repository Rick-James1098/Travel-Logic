enum TravelRecordType {
  destination('destination', '숙소'),
  transport('transport', '교통'),
  activity('activity', '활동');

  const TravelRecordType(this.value, this.label);
  final String value;
  final String label;
}

enum TransportType {
  airplane('airplane', '비행기'),
  rental('rental', '렌트카'),
  train('train', '기차'),
  bus('bus', '버스'),
  other('other', '기타');

  const TransportType(this.value, this.label);
  final String value;
  final String label;
}

class TransportDetails {
  final TransportType transportType;
  // 비행기
  final String? airline;
  final String? flightNumber;
  final String? departureTime;
  final String? arrivalTime;
  final String? reservationNumber;
  final String? boardingPass;
  // 렌트카
  final String? rentalCompany;
  final String? vehicle;
  final String? rentalPeriod;
  final String? voucher;
  final String? rentalDetails;
  // 기차/버스
  final String? trainName;
  final String? busName;
  final String? departure;
  final String? arrival;
  final String? seat;

  TransportDetails({
    required this.transportType,
    this.airline,
    this.flightNumber,
    this.departureTime,
    this.arrivalTime,
    this.reservationNumber,
    this.boardingPass,
    this.rentalCompany,
    this.vehicle,
    this.rentalPeriod,
    this.voucher,
    this.rentalDetails,
    this.trainName,
    this.busName,
    this.departure,
    this.arrival,
    this.seat,
  });
}

class AccommodationDetails {
  final String? bookingSite;
  final String? bookingSiteLink;
  final String? address;
  final String? checkIn;
  final String? checkOut;

  AccommodationDetails({
    this.bookingSite,
    this.bookingSiteLink,
    this.address,
    this.checkIn,
    this.checkOut,
  });
}

class TravelRecord {
  final String id;
  final String tripPlanId;
  final TravelRecordType type;
  final String title;
  final String description;
  final String location;
  final String time;
  final String date;
  final int amount;
  final String? image;
  final TransportDetails? transportDetails;
  final AccommodationDetails? accommodationDetails;

  TravelRecord({
    required this.id,
    required this.tripPlanId,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.date,
    required this.amount,
    this.image,
    this.transportDetails,
    this.accommodationDetails,
  });

  TravelRecord copyWith({
    String? id,
    String? tripPlanId,
    TravelRecordType? type,
    String? title,
    String? description,
    String? location,
    String? time,
    String? date,
    int? amount,
    String? image,
    TransportDetails? transportDetails,
    AccommodationDetails? accommodationDetails,
  }) {
    return TravelRecord(
      id: id ?? this.id,
      tripPlanId: tripPlanId ?? this.tripPlanId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      time: time ?? this.time,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      image: image ?? this.image,
      transportDetails: transportDetails ?? this.transportDetails,
      accommodationDetails: accommodationDetails ?? this.accommodationDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripPlanId': tripPlanId,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'location': location,
      'time': time,
      'date': date,
      'amount': amount,
      'image': image,
      'transportType': transportDetails?.transportType.toString().split('.').last,
      'airline': transportDetails?.airline,
      'flightNumber': transportDetails?.flightNumber,
      'departureTime': transportDetails?.departureTime,
      'arrivalTime': transportDetails?.arrivalTime,
      'reservationNumber': transportDetails?.reservationNumber,
      'boardingPass': transportDetails?.boardingPass,
      'rentalCompany': transportDetails?.rentalCompany,
      'vehicle': transportDetails?.vehicle,
      'rentalPeriod': transportDetails?.rentalPeriod,
      'voucher': transportDetails?.voucher,
      'rentalDetails': transportDetails?.rentalDetails,
      'trainName': transportDetails?.trainName,
      'busName': transportDetails?.busName,
      'departure': transportDetails?.departure,
      'arrival': transportDetails?.arrival,
      'seat': transportDetails?.seat,
      'bookingSite': accommodationDetails?.bookingSite,
      'bookingSiteLink': accommodationDetails?.bookingSiteLink,
      'address': accommodationDetails?.address,
      'checkIn': accommodationDetails?.checkIn,
      'checkOut': accommodationDetails?.checkOut,
    };
  }

  factory TravelRecord.fromMap(Map<String, dynamic> map) {
    return TravelRecord(
      id: map['id'],
      tripPlanId: map['tripPlanId'],
      type: TravelRecordType.values.firstWhere((e) => e.toString().split('.').last == map['type']),
      title: map['title'],
      description: map['description'],
      location: map['location'],
      time: map['time'],
      date: map['date'],
      amount: map['amount'],
      image: map['image'],
      transportDetails: map['transportType'] != null
          ? TransportDetails(
              transportType: TransportType.values.firstWhere((e) => e.toString().split('.').last == map['transportType']),
              airline: map['airline'],
              flightNumber: map['flightNumber'],
              departureTime: map['departureTime'],
              arrivalTime: map['arrivalTime'],
              reservationNumber: map['reservationNumber'],
              boardingPass: map['boardingPass'],
              rentalCompany: map['rentalCompany'],
              vehicle: map['vehicle'],
              rentalPeriod: map['rentalPeriod'],
              voucher: map['voucher'],
              rentalDetails: map['rentalDetails'],
              trainName: map['trainName'],
              busName: map['busName'],
              departure: map['departure'],
              arrival: map['arrival'],
              seat: map['seat'],
            )
          : null,
      accommodationDetails: map['bookingSite'] != null || map['address'] != null
          ? AccommodationDetails(
              bookingSite: map['bookingSite'],
              bookingSiteLink: map['bookingSiteLink'],
              address: map['address'],
              checkIn: map['checkIn'],
              checkOut: map['checkOut'],
            )
          : null,
    );
  }
}