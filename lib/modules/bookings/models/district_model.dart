class DistrictModel {
  final String districtId;
  final String districtName;

  const DistrictModel({
    required this.districtId,
    required this.districtName,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      districtId: json['districtId'] ?? '',
      districtName: json['districtName'] ?? '',
    );
  }
}