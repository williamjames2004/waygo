import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  final Map<String, dynamic>? passenger;

  const ProfileDrawer({
    super.key,
    required this.passenger,
  });

  @override
  Widget build(BuildContext context) {
    final name = passenger?['name'] ?? 'Passenger';
    final phone = passenger?['phone'] ?? '';
    final email = passenger?['email'] ?? '';

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (phone.toString().isNotEmpty)
                    Text(
                      phone.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  if (email.toString().isNotEmpty)
                    Text(
                      email.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            _drawerItem(
              context,
              icon: Icons.person_outline,
              title: "My Profile",
              onTap: () {
                Navigator.pop(context);
                // TODO: Open profile screen
              },
            ),

            _drawerItem(
              context,
              icon: Icons.history,
              title: "Travel History",
              onTap: () {
                Navigator.pop(context);
                // TODO: Open travel history
              },
            ),

            _drawerItem(
              context,
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {
                Navigator.pop(context);
                // TODO: Open settings
              },
            ),

            _drawerItem(
              context,
              icon: Icons.info_outline,
              title: "About WayGO",
              onTap: () {
                Navigator.pop(context);
                // TODO: Open about screen
              },
            ),

            const Spacer(),

            const Divider(),

            _drawerItem(
              context,
              icon: Icons.logout,
              title: "Logout",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false,
                );
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color? color,
      }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      onTap: onTap,
    );
  }
}