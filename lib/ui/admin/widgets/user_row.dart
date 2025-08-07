import 'package:crm_clinic/data/model/user_model.dart';
import 'package:flutter/material.dart';

TableRow userRow(UserModel user) {
  return TableRow(children: [
    cell(user.fullName),
    cell(user.email),
    cell(user.joined.toString()),
    Padding(
      padding: const EdgeInsets.all(8),
      child: Chip(
        label: Text(permissionLabel(user.permission),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: permissionColor(user.permission),
        // labelStyle: TextStyle(color: permissionColor(user.permission)),
      ),
    ),
  ]);
}

Color permissionColor(UserPermission permission) {
  switch (permission) {
    case UserPermission.admin:
      return Colors.red;
    case UserPermission.contributor:
      return Colors.blue;
    case UserPermission.viewer:
      return Colors.grey;
  }
}

String permissionLabel(UserPermission permission) {
  return permission.name[0].toUpperCase() + permission.name.substring(1);
}

Widget cell(String text) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: const TextStyle(
            fontSize: 14,
          )),
    );




//   String _monthName(int month) {
//     const months = [
//       "January",
//       "February",
//       "March",
//       "April",
//       "May",
//       "June",
//       "July",
//       "August",
//       "September",
//       "October",
//       "November",
//       "December"
//     ];
//     return months[month - 1];
//   }
// }
        // _cell("Full Name"),
        //     _cell("Email Address"),
        //     _cell("joined"),
        //     _cell("Permission"),
