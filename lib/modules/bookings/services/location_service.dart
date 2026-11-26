import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/booking_constants.dart';
import '../models/district_model.dart';
import '../models/busstand_model.dart';
import '../models/busstop_model.dart';

class LocationService {
  // Get all active districts
  Future<List<DistrictModel>> getDistricts() async {
    final response = await http.get(
      Uri.parse('${BookingConstants.baseUrl}/districts'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return (data['districts'] as List)
            .map((item) => DistrictModel.fromJson(item))
            .toList();
      }

      throw Exception(data['message'] ?? 'Failed to load districts');
    }

    throw Exception('Unable to load districts');
  }

  // Get bus stands belonging to a district
  Future<List<BusStandModel>> getBusStands(String districtId) async {
    final response = await http.get(
      Uri.parse(
        '${BookingConstants.baseUrl}/busstands/district/$districtId',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return (data['busStands'] as List)
            .map((item) => BusStandModel.fromJson(item))
            .toList();
      }

      throw Exception(data['message'] ?? 'Failed to load bus stands');
    }

    throw Exception('Unable to load bus stands');
  }

  // Get bus stops belonging to a bus stand
  Future<List<BusStopModel>> getBusStops(String busstandId) async {
    final response = await http.get(
      Uri.parse(
        '${BookingConstants.baseUrl}/busstops/busstand/$busstandId',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return (data['busStops'] as List)
            .map((item) => BusStopModel.fromJson(item))
            .toList();
      }

      throw Exception(data['message'] ?? 'Failed to load bus stops');
    }

    throw Exception('Unable to load bus stops');
  }
}