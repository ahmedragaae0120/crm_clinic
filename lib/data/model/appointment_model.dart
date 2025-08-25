class AppointmentModel {
  String? id;
  String? patientId;
  String? doctorId;
  DateTime? dateTime;
  String? status;

  AppointmentModel({
    this.id,
    this.patientId,
    this.doctorId,
    this.dateTime,
    this.status = 'booked',
  });

  Map<String, dynamic> toJson() => {
    'patientId': patientId,
    'doctorId': doctorId,
    'dateTime': dateTime?.toIso8601String(),
    'status': status,
    'createdAt': DateTime.now(),
  };

  AppointmentModel.fromJson(Map<String, dynamic> json, String id) {
    this.id = json['appointmentId'] as String?;
    patientId = json['patientId'] as String?;
    doctorId = json['doctorId'] as String?;
    dateTime = DateTime.parse(json['dateTime']);
    status = json['status'] as String?;
  }
}
