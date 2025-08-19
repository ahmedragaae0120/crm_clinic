import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/ui/admin/widgets/add_user_dialog.dart';
import 'package:crm_clinic/ui/admin/widgets/admin_drawer.dart';
import 'package:crm_clinic/ui/admin/widgets/users_table.dart';
import 'package:flutter/material.dart';

class AdminMobileBody extends StatelessWidget {
  const AdminMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.admin)),
      drawer: const AdminDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text(
                  AppStrings.userManagament,
                  style: theme.textTheme.headlineLarge,
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
                    child: Text(
                      AppStrings.newUser,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Config.spaceMedium,
                const UsersTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
