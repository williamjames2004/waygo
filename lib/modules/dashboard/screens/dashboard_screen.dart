import 'package:flutter/material.dart';
import 'package:waygo/modules/bookings/screens/search_bus_screen.dart';

import '../../../core/utils/responsive.dart';

import '../pages/home_page.dart';
import '../pages/track_page.dart';
import '../pages/tickets_page.dart';

import '../widgets/dashboard_app_bar.dart';
import '../widgets/profile_drawer.dart';

import 'notifications_screen.dart';
import 'support_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? passenger;

  const DashboardScreen({
    super.key,
    this.passenger,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  late List<Widget> pages = [
    HomePage(
      passengerName: widget.passenger?['name'] ?? 'Passenger',
    ),
    const SearchBusScreen(),
    const TrackPage(),
    const TicketsPage(),
  ];

  final List<String> pageTitles = const [
    "Home",
    "Bookings",
    "Track",
    "Tickets",
  ];

  void openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  }

  void openSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SupportScreen(),
      ),
    );
  }

  void openProfileDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: DashboardAppBar(
        passengerName: widget.passenger?['name'] ?? 'Passenger',
        onProfileTap: () {
          // Open the drawer using the Scaffold key below.
          _scaffoldKey.currentState?.openDrawer();
        },
        onNotificationsTap: openNotifications,
        onSupportTap: openSupport,
      ),

      key: _scaffoldKey,

      drawer: ProfileDrawer(
        passenger: widget.passenger,
      ),

      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month),
                  label: Text("Bookings"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.location_on_outlined),
                  selectedIcon: Icon(Icons.location_on),
                  label: Text("Track"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.confirmation_number_outlined),
                  selectedIcon: Icon(Icons.confirmation_number),
                  label: Text("Tickets"),
                ),
              ],
            ),

          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),

      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: "Bookings",
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: "Track",
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: "Tickets",
          ),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
}