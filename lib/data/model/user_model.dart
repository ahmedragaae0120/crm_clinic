import 'package:cloud_firestore/cloud_firestore.dart';

enum UserPermission {
  admin("Admin"),
  doctor("Doctor"),
  nurse("Nurse"),
  receptionist("Receptionist");

  final String name;
  const UserPermission(this.name);
}

class UserModel {
  final String? fullName;
  final String? email;
  final DateTime? joined;
  final String? permission;

  const UserModel({
    this.fullName,
    this.email,
    this.joined,
    this.permission,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      joined: json['joined'] is Timestamp
          ? (json['joined'] as Timestamp).toDate()
          : DateTime.tryParse(json['joined']?.toString() ?? ''),
      permission: json['permission'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'joined': joined?.toIso8601String(),
      'permission': permission,
    };
  }
}
