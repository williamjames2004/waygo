
class RouteStopModel {
  final String busstopId;
  final int sequence;
  final DateTime? departureDateTime;

  const RouteStopModel({
    required this.busstopId,
    required this.sequence,
    this.departureDateTime,
  });

  factory RouteStopModel.fromJson(Map<String, dynamic> json) {
    return RouteStopModel(
      busstopId: json['busstopId']?.toString() ?? '',
      sequence: (json['sequence'] as num?)?.toInt() ?? 0,
      departureDateTime: json['departureDateTime'] != null
          ? DateTime.tryParse(json['departureDateTime'].toString())
          : null,
    );
  }
}

class RouteModel {
  final String routeId;
  final String startingBusstandId;
  final String endingBusstandId;
  final String startingDistrictId;
  final String endingDistrictId;
  final String busId;
  final DateTime? departureTime;
  final DateTime? reachingTime;
  final DateTime? travelDate;
  final int totalSeats;
  final double price;
  final String category;
  final String busType;
  final List<RouteStopModel> stops;
  final String status;

  const RouteModel({
    required this.routeId,
    required this.startingBusstandId,
    required this.endingBusstandId,
    required this.startingDistrictId,
    required this.endingDistrictId,
    required this.busId,
    this.departureTime,
    this.reachingTime,
    this.travelDate,
    required this.totalSeats,
    required this.price,
    required this.category,
    required this.busType,
    required this.stops,
    required this.status,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      routeId: json['routeId']?.toString() ?? '',
      startingBusstandId:
      json['startingBusstandId']?.toString() ?? '',
      endingBusstandId:
      json['endingBusstandId']?.toString() ?? '',
      startingDistrictId:
      json['startingDistrictId']?.toString() ?? '',
      endingDistrictId:
      json['endingDistrictId']?.toString() ?? '',
      busId: json['busId']?.toString() ?? '',
      departureTime: json['departureTime'] != null
          ? DateTime.tryParse(json['departureTime'].toString())
          : null,
      reachingTime: json['reachingTime'] != null
          ? DateTime.tryParse(json['reachingTime'].toString())
          : null,
      travelDate: json['travelDate'] != null
          ? DateTime.tryParse(json['travelDate'].toString())
          : null,
      totalSeats: (json['totalSeats'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? '',
      busType: json['busType']?.toString() ?? '',
      stops: (json['stops'] as List? ?? [])
          .map(
            (item) => RouteStopModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
      status: json['status']?.toString() ?? '',
    );
  }
}
