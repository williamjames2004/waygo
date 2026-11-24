import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String passengerName;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onSupportTap;

  const DashboardAppBar({
    super.key,
    required this.passengerName,
    required this.onProfileTap,
    required this.onNotificationsTap,
    required this.onSupportTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: onProfileTap,
          icon: CircleAvatar(
            radius: 17,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      title: const Text(
        "WayGO",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: onNotificationsTap,
          tooltip: "Notifications",
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(
          onPressed: onSupportTap,
          tooltip: "Support",
          icon: const Icon(Icons.support_agent),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}