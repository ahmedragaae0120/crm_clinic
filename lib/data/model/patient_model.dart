import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  String? uid;
  String? fullName;
  String? phone;
  String? birthDate;
  String? gender;
  DateTime? joined;

  PatientModel(
      {this.fullName,
      this.joined,
      this.uid,
      this.phone,
      this.birthDate,
      this.gender});

  PatientModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'] as String?;
    joined = json['joined'] is Timestamp
        ? (json['joined'] as Timestamp).toDate()
        : DateTime.tryParse(json['joined']?.toString() ?? '');
    uid = json['uid'] as String?;
    phone = json['phone'] as String?;
    birthDate = json['birthDate'] as String?;
    gender = json['gender'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'joined': joined,
      'uid': uid,
      'phone': phone,
      'birthDate': birthDate,
      'gender': gender,
    };
  }
}
