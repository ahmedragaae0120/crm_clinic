import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/ui/admin/widgets/add_user_dialog.dart';
import 'package:crm_clinic/ui/admin/widgets/admin_drawer.dart';
import 'package:crm_clinic/ui/admin/widgets/users_table.dart';
import 'package:flutter/material.dart';

class AdminDesktopBody extends StatelessWidget {
  const AdminDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 250,
            height: double.infinity,
            child: AdminDrawer(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "User Managament",
                        style: theme.textTheme.headlineLarge,
                      ),
                      Config.spaceSmall,
                      Text(
                        "Manage your users here",
                        style: theme.textTheme.headlineMedium!
                            .copyWith(color: theme.colorScheme.primary),
                      ),
                      Config.spaceSmall,
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const AddUserDialog(),
                            );
                          },
                          child: Text("+ New User",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.onPrimary)),
                        ),
                      ),
                      Config.spaceMedium,
                      const UsersTable(),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
