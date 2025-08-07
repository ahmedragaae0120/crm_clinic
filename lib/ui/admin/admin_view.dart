import 'package:crm_clinic/ui/admin/widgets/admin_drawer.dart';
import 'package:crm_clinic/ui/admin/widgets/users_table.dart';
import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      drawer: AdminDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Text(
                    "User Managament",
                    style: theme.textTheme.headlineLarge,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("+ New User",
                          style: theme.textTheme.bodyLarge!
                              .copyWith(color: theme.colorScheme.onPrimary)),
                    ),
                  ),
                  const UsersTable()
                ]),
          ),
        ),
      ),
    );
  }
}
