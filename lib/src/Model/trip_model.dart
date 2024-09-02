class TripModel {
  final int id;
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final String leavingTime;
  final String date;
  final double price;
  final String departureDate;
  final String departureTime;
  final String arrivalDate;
  final String arrivalTime;
  final String travelHours;

  TripModel({
    required this.id,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.leavingTime,
    required this.date,
    required this.price,
    required this.departureDate,
    required this.departureTime,
    required this.arrivalDate,
    required this.arrivalTime,
    required this.travelHours,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    final priceString = json['price'] as String;
    final price = double.tryParse(priceString);
    if (price == null) {
      print('Failed to parse price: $priceString');
    }
    return TripModel(
      id: json['id'] as int,
      fromCode: json['fromCode'] as String,
      fromName: json['fromName'] as String,
      toCode: json['toCode'] as String,
      toName: json['toName'] as String,
      leavingTime: json['leavingTime'] as String,
      date: json['date'] as String,
      price: price ?? 0.0,
      departureDate: json['departureDate'] as String,
      departureTime: json['departureTime'] as String,
      arrivalDate: json['arrivalDate'] as String,
      arrivalTime: json['arrivalTime'] as String,
      travelHours: json['travelHours'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': fromName,
      'to': toName,
      'date': date,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      // Add other properties as needed
    };
  }
}
