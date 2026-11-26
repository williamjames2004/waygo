
import 'package:flutter/material.dart';

import '../models/route_model.dart';

class BusDetailsScreen extends StatelessWidget {
  final RouteModel route;

  final String startingBusstopId;
  final String endingBusstopId;
  final String journeyDate;

  final VoidCallback onProceed;

  const BusDetailsScreen({
    super.key,
    required this.route,
    required this.startingBusstopId,
    required this.endingBusstopId,
    required this.journeyDate,
    required this.onProceed,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';

    final time = dateTime.toLocal();
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  RouteStopModel? _getStop(String busstopId) {
    for (final stop in route.stops) {
      if (stop.busstopId == busstopId) {
        return stop;
      }
    }

    return null;
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 21, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyPoint({
    required String title,
    required String busstopId,
    required DateTime? time,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                busstopId,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(time),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final startingStop = _getStop(startingBusstopId);
    final endingStop = _getStop(endingBusstopId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Details'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor:
                              theme.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.directions_bus,
                                size: 28,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    route.busId,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${route.category} • ${route.busType}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatTime(route.departureTime),
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Departure'),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatTime(route.reachingTime),
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Arrival'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Journey',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildJourneyPoint(
                          title: 'Boarding Point',
                          busstopId: startingBusstopId,
                          time: startingStop?.departureDateTime,
                          icon: Icons.trip_origin,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 32,
                            width: 2,
                            color: Colors.grey.shade400,
                          ),
                        ),

                        _buildJourneyPoint(
                          title: 'Dropping Point',
                          busstopId: endingBusstopId,
                          time: endingStop?.departureDateTime,
                          icon: Icons.location_on,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bus Information',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildDetailRow(
                          icon: Icons.confirmation_number_outlined,
                          title: 'Route ID',
                          value: route.routeId,
                        ),

                        _buildDetailRow(
                          icon: Icons.calendar_today_outlined,
                          title: 'Journey Date',
                          value: journeyDate,
                        ),

                        _buildDetailRow(
                          icon: Icons.event_seat_outlined,
                          title: 'Total Seats',
                          value: route.totalSeats.toString(),
                        ),

                        _buildDetailRow(
                          icon: Icons.directions_bus_outlined,
                          title: 'Bus Type',
                          value: route.busType,
                        ),

                        _buildDetailRow(
                          icon: Icons.category_outlined,
                          title: 'Category',
                          value: route.category,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Fare per passenger',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${route.price.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.payments_outlined,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onProceed,
                    icon: const Icon(Icons.event_seat),
                    label: const Text('Proceed to Book a Ticket'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
