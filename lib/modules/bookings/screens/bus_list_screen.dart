
import 'package:flutter/material.dart';
import 'package:waygo/modules/bookings/screens/bus_details_screen.dart';

import '../models/route_model.dart';
import '../services/booking_service.dart';
import '../widgets/bus_card.dart';

class BusListScreen extends StatefulWidget {
  final String startingDistrictId;
  final String endingDistrictId;
  final String startingBusstandId;
  final String endingBusstandId;
  final String startingBusstopId;
  final String endingBusstopId;
  final String journeyDate;

  const BusListScreen({
    super.key,
    required this.startingDistrictId,
    required this.endingDistrictId,
    required this.startingBusstandId,
    required this.endingBusstandId,
    required this.startingBusstopId,
    required this.endingBusstopId,
    required this.journeyDate,
  });

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final BookingService _bookingService = BookingService();

  List<RouteModel> _routes = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchRoutes();
  }

  Future<void> _searchRoutes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final routes = await _bookingService.searchRoutes(
        startingBusstandId: widget.startingBusstandId,
        endingBusstandId: widget.endingBusstandId,
      );

      final matchingRoutes = routes.where((route) {
        // Check whether the requested date matches the route date.
        if (route.travelDate == null ||
            !_isSameDate(route.travelDate!, widget.journeyDate)) {
          return false;
        }

        // Find the selected boarding and dropping stops.
        final startingStop = route.stops
            .where((stop) => stop.busstopId == widget.startingBusstopId)
            .toList();

        final endingStop = route.stops
            .where((stop) => stop.busstopId == widget.endingBusstopId)
            .toList();

        if (startingStop.isEmpty || endingStop.isEmpty) {
          return false;
        }

        // Boarding stop must occur before dropping stop.
        return startingStop.first.sequence < endingStop.first.sequence;
      }).toList();

      if (!mounted) return;

      setState(() {
        _routes = matchingRoutes;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  bool _isSameDate(DateTime routeDate, String requestedDate) {
    final date = routeDate.toLocal();

    final formattedDate =
        '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    return formattedDate == requestedDate;
  }

  void _openBusDetails(RouteModel route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusDetailsScreen(
          route: route,
          startingBusstopId: widget.startingBusstopId,
          endingBusstopId: widget.endingBusstopId,
          journeyDate: widget.journeyDate,
          onProceed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Seat booking screen is coming next.'),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                'Unable to load buses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _searchRoutes,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_routes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_bus_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No matching buses found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'There are no regular buses matching your '
                    'selected journey and date.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _searchRoutes,
                icon: const Icon(Icons.refresh),
                label: const Text('Search Again'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Demand-based travel options will be shown here next.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _routes.length,
      itemBuilder: (context, index) {
        final route = _routes[index];

        return BusCard(
          route: route,
          onTap: () => _openBusDetails(route),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Buses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Journey date: ${widget.journeyDate}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (!_loading && _error == null)
                  Text(
                    '${_routes.length} buses',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
