import 'package:crm_clinic/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TableRow userRow(UserModel user) {
  final enumPermission = toEnum(user.permission ?? "");

  return TableRow(children: [
    cell(user.fullName ?? ""),
    cell(user.email ?? ""),
    cell(formatDate(user.joined ?? DateTime.now())),
    Padding(
      padding: const EdgeInsets.all(8),
      child: Chip(
        label: Text(enumPermission.name,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: permissionColor(enumPermission),
        // labelStyle: TextStyle(color: permissionColor(user.permission)),
      ),
    ),
  ]);
}

String formatDate(DateTime date) {
  return DateFormat('MMMM d, yyyy h:mm: a').format(date);
}

Color permissionColor(UserPermission permission) {
  switch (permission) {
    case UserPermission.admin:
      return Colors.red;
    case UserPermission.doctor:
      return Colors.blueAccent;
    case UserPermission.nurse:
      return Colors.lightBlueAccent;
    case UserPermission.receptionist:
      return Colors.grey;
  }
}

UserPermission toEnum(String permission) {
  return UserPermission.values.firstWhere(
    (e) => e.name.toLowerCase() == permission.toLowerCase(),
    orElse: () => UserPermission.receptionist, // Default لو مفيش تطابق
  );
}

Widget cell(String text) => Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
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
