
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/booking_constants.dart';
import '../models/route_model.dart';

class BookingService {
  // Search routes between two bus stands
  Future<List<RouteModel>> searchRoutes({
    required String startingBusstandId,
    required String endingBusstandId,
  }) async {
    final uri = Uri.parse(
      '${BookingConstants.baseUrl}/routes/busstands/search',
    ).replace(
      queryParameters: {
        'startingBusstandId': startingBusstandId,
        'endingBusstandId': endingBusstandId,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return (data['routes'] as List? ?? [])
            .map(
              (item) => RouteModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();
      }

      throw Exception(data['message'] ?? 'Failed to search routes');
    }

    throw Exception('Unable to search routes');
  }

  // Get individual route details
  Future<RouteModel> getRoute(String routeId) async {
    final uri = Uri.parse(
      '${BookingConstants.baseUrl}/routes/${Uri.encodeComponent(routeId)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return RouteModel.fromJson(
          Map<String, dynamic>.from(data['route']),
        );
      }

      throw Exception(data['message'] ?? 'Failed to load route details');
    }

    throw Exception('Unable to load route details');
  }
}
