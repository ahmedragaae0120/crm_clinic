import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? appointmentId;
  String? patientId;
  String? doctorId;
  String? doctorName;
  DateTime? dateTime;
  String? status;
  String? patientName;
  String? patientPhone;
  String? slotId; // 👈 نربط الـ appointment بالـ slot

  AppointmentModel({
    this.appointmentId,
    this.patientId,
    this.doctorId,
    this.doctorName,
    this.dateTime,
    this.status = 'booked',
    this.patientName,
    this.patientPhone,
    this.slotId,
  });

  Map<String, dynamic> toJson() => {
    'appointmentId': appointmentId,
    'patientId': patientId,
    'doctorId': doctorId,
    'doctorName': doctorName,
    'dateTime': dateTime != null ? Timestamp.fromDate(dateTime!) : null,
    'status': status,
    'createdAt': DateTime.now(),
    'patientName': patientName,
    'patientPhone': patientPhone,
    'slotId': slotId,
  };

  AppointmentModel.fromJson(Map<String, dynamic> json, String id) {
    appointmentId = json['appointmentId'] as String?;
    patientId = json['patientId'] as String?;
    doctorId = json['doctorId'] as String?;
    doctorName = json['doctorName'] as String?;
    dateTime = (json['dateTime'] is Timestamp)
        ? (json['dateTime'] as Timestamp).toDate()
        : null; //DateTime.parse(json['dateTime']);
    status = json['status'] as String?;
    patientName = json['patientName'] as String?;
    patientPhone = json['patientPhone'] as String?;
    slotId = json['slotId'] as String?;
  }
}
