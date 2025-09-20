enum TravelRecordType {
  destination('destination', '숙소'),
  transport('transport', '교통수단'),
  activity('activity', '액티비티');

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
}