import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[800],
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
                Navigator.pop(context);
                // ضع التنقل إلى صفحة الداشبورد هنا
              },
            ),
            drawerItem(
              icon: Icons.logout,
              text: 'Logout',
              context: context,
              onTap: () {
                Navigator.pop(context);
                // ضع منطق تسجيل الخروج هنا
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
