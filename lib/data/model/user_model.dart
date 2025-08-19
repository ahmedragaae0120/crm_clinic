import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

enum UserPermission {
  admin("admin"),
  doctor("doctor"),
  nurse("nurse"),
  receptionist("receptionist");

  final String value;
  const UserPermission(this.value);
  String get name => value.tr();
}

class UserModel {
  final String? fullName;
  final String? email;
  final DateTime? joined;
  final String? permission;
  final String? uid;

  const UserModel({
    this.fullName,
    this.email,
    this.joined,
    this.permission,
    this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      joined: json['joined'] is Timestamp
          ? (json['joined'] as Timestamp).toDate()
          : DateTime.tryParse(json['joined']?.toString() ?? ''),
      permission: json['permission'] as String?,
      uid: json['uid'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'joined': joined?.toIso8601String(),
      'permission': permission,
      'uid': uid,
    };
  }
}
