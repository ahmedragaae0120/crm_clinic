import 'package:crm_clinic/core/utils/app_routes.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Container(
        color: theme.colorScheme.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            drawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              context: context,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.admin, (_) => false);
              },
            ),
            drawerItem(
              icon: Icons.logout,
              text: 'Logout',
              context: context,
              onTap: () {
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      required BuildContext context}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onPrimary),
      title: Text(text, style: TextStyle(color: theme.colorScheme.onPrimary)),
      onTap: onTap,
    );
  }
}
