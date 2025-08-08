import 'package:crm_clinic/ui/admin/view_model/admin_cubit.dart';
import 'package:crm_clinic/ui/admin/widgets/user_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        switch (state) {
          case GetAllUsersSuccess():
            return Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                  borderRadius: BorderRadius.circular(5)),
              children: [
                _buildHeader(context),
                ...state.users.map(
                  (users) => userRow(users),
                ),
              ],
            );

          case GetAllUsersFailed():
            return Center(
                child:
                    Text(state.message, style: theme.textTheme.headlineLarge));
          case GetAllUsersLoading():
            return const Center(child: CircularProgressIndicator.adaptive());
          default:
            return Text("something went wrong ",
                style: theme.textTheme.headlineLarge);
        }
      },
    );
  }

  TableRow _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Full Name",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Email, Address",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Joined",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Permissions",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary)),
        ),
      ],
    );
  }
}
