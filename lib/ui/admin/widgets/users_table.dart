import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/ui/admin/view_model/admin_cubit.dart';
import 'package:crm_clinic/ui/admin/view_model/admin_state.dart';
import 'package:crm_clinic/ui/admin/widgets/user_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AdminCubit, AdminState>(
      buildWhen: (previous, current) {
        if (current is GetAllUsersSuccess ||
            current is GetAllUsersFailed ||
            current is GetAllUsersLoading) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        switch (state) {
          case GetAllUsersSuccess():
            return Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                color: theme.colorScheme.primary,
                width: 2,
                borderRadius: BorderRadius.circular(5),
              ),
              children: [
                _buildHeader(context),
                ...state.users.map((users) => userRow(users, context)),
              ],
            );

          case GetAllUsersFailed():
            return Center(
              child: Text(state.message, style: theme.textTheme.headlineLarge),
            );
          case GetAllUsersLoading():
            return const Center(child: CircularProgressIndicator.adaptive());
          default:
            return Text(
              AppStrings.somethingWentWrong,
              style: theme.textTheme.headlineLarge,
            );
        }
      },
    );
  }

  TableRow _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return TableRow(
      decoration: BoxDecoration(color: theme.colorScheme.primary),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.fullName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.emailLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.joined,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.permissions,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.remove_circle_outline_outlined,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
