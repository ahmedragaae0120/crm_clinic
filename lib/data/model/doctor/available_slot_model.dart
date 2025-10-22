import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableSlotModel {
  final String? id;
  final DateTime? startTime;
  final String? status;

  AvailableSlotModel({this.id, this.startTime, this.status});

  factory AvailableSlotModel.fromJson(Map<String, dynamic>? json, String id) {
    if (json == null) {
      return AvailableSlotModel(id: id);
    }
    return AvailableSlotModel(
      id: id,
      startTime: (json['startTime'] is Timestamp)
          ? (json['startTime'] as Timestamp).toDate()
          : null,
      status: json['status'] as String?,
    );
  }

  // من Model -> Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'status': status,
    };
  }
}
