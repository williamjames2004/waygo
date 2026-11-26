class BusStopModel {
  final String busstopId;
  final String busstopName;
  final String busstandId;
  final String districtId;

  const BusStopModel({
    required this.busstopId,
    required this.busstopName,
    required this.busstandId,
    required this.districtId,
  });

  factory BusStopModel.fromJson(Map<String, dynamic> json) {
    return BusStopModel(
      busstopId: json['busstopId'] ?? '',
      busstopName: json['busstopName'] ?? '',
      busstandId: json['busstandId'] ?? '',
      districtId: json['districtId'] ?? '',
    );
  }
}