class BusStandModel {
  final String busstandId;
  final String busstandName;
  final String districtId;

  const BusStandModel({
    required this.busstandId,
    required this.busstandName,
    required this.districtId,
  });

  factory BusStandModel.fromJson(Map<String, dynamic> json) {
    return BusStandModel(
      busstandId: json['busstandId'] ?? '',
      busstandName: json['busstandName'] ?? '',
      districtId: json['districtId'] ?? '',
    );
  }
}