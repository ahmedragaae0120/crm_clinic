import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/ui/admin/widgets/user_row.dart';
import 'package:flutter/material.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<UserModel> users = [
      UserModel(
          fullName: "Leslie Maya",
          email: "leslie@gmail.com",
          joined: DateTime(2010, 10, 2),
          permission: UserPermission.admin),
      UserModel(
          fullName: "Josie Deck",
          email: "josie@gmail.com",
          joined: DateTime(2011, 10, 1),
          permission: UserPermission.admin),
      UserModel(
          fullName: "Alex Pfeffer",
          email: "alex@gmail.com",
          joined: DateTime(2015, 5, 20),
          permission: UserPermission.admin),
      UserModel(
          fullName: "Mike Dean",
          email: "mike@gmail.com",
          joined: DateTime(2015, 7, 14),
          permission: UserPermission.contributor),
      UserModel(
          fullName: "Mateus Cunha",
          email: "cunha@gmail.com",
          joined: DateTime(2016, 6, 5),
          permission: UserPermission.contributor),
      UserModel(
          fullName: "Nezab Uemo",
          email: "nezab@gmail.com",
          joined: DateTime(2016, 6, 1),
          permission: UserPermission.viewer),
      UserModel(
          fullName: "Antony Mack",
          email: "mack@gmail.com",
          joined: DateTime(2016, 6, 15),
          permission: UserPermission.contributor),
      UserModel(
          fullName: "Andre da Silva",
          email: "andre@gmail.com",
          joined: DateTime(2018, 3, 13),
          permission: UserPermission.contributor),
      UserModel(
          fullName: "Jorge Ferreira",
          email: "jorge@gmail.com",
          joined: DateTime(2018, 3, 14),
          permission: UserPermission.contributor),
      UserModel(
          fullName: "Jorge Ferreira",
          email: "jorge@gmail.com",
          joined: DateTime(2018, 3, 14),
          permission: UserPermission.contributor),
      UserModel(
          fullName: "Jorge Ferreira",
          email: "jorge@gmail.com",
          joined: DateTime(2018, 3, 14),
          permission: UserPermission.contributor),
    ];
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: theme.colorScheme.primary,
        width: 2,
      ),
      children: [
        _buildHeader(),
        ...users.map(
          (users) => userRow(users),
        )
      ],
    );
  }

  TableRow _buildHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.black12),
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Email Address",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Joined", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Permissions",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
