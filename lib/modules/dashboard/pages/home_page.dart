
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String passengerName;

  const HomePage({
    super.key,
    this.passengerName = "Passenger",
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void swapLocations() {
    final temp = fromController.text;

    setState(() {
      fromController.text = toController.text;
      toController.text = temp;
    });
  }

  void searchBuses() {
    if (fromController.text.trim().isEmpty ||
        toController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter starting and destination locations"),
        ),
      );
      return;
    }

    if (fromController.text.trim().toLowerCase() ==
        toController.text.trim().toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Starting point and destination cannot be the same"),
        ),
      );
      return;
    }

    // TODO: Connect the bus search API.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Bus search will be connected next"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${widget.passengerName}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Where would you like to go today?",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 25),

              _buildSearchCard(context),

              const SizedBox(height: 30),

              Text(
                "Quick Access",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              LayoutBuilder(
                builder: (context, constraints) {
                  final count = constraints.maxWidth >= 650 ? 3 : 2;

                  return GridView.count(
                    crossAxisCount: count,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _quickAccessCard(
                        context,
                        Icons.confirmation_number_outlined,
                        "My Bookings",
                        "View your bookings",
                      ),
                      _quickAccessCard(
                        context,
                        Icons.location_on_outlined,
                        "Track Bus",
                        "Follow your journey",
                      ),
                      _quickAccessCard(
                        context,
                        Icons.receipt_long_outlined,
                        "My Tickets",
                        "View your tickets",
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              Text(
                "Travel with WayGO",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.directions_bus_rounded,
                      size: 38,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your journey, made easier.",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Find buses, reserve seats and track your journey "
                          "with WayGO.",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  "Find Your Bus",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _locationField(
                    controller: fromController,
                    label: "From",
                    hint: "Starting bus stand",
                    icon: Icons.trip_origin,
                  ),
                ),

                IconButton(
                  onPressed: swapLocations,
                  tooltip: "Swap locations",
                  icon: const Icon(Icons.swap_horiz_rounded),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _locationField(
              controller: toController,
              label: "To",
              hint: "Destination bus stand",
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 18),

            InkWell(
              onTap: selectDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Journey Date",
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
                child: Text(
                  "${selectedDate.day.toString().padLeft(2, '0')}/"
                      "${selectedDate.month.toString().padLeft(2, '0')}/"
                      "${selectedDate.year}",
                ),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: searchBuses,
                icon: const Icon(Icons.search),
                label: const Text(
                  "Search Buses",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _quickAccessCard(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 27,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
