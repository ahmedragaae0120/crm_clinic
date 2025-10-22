import 'package:crm_clinic/core/result.dart';

abstract interface class UpdateAppointmentTimeDatasource {
  Future<Result<void>> updateAppointmentTime({
    required String appointmentId, // ID الحجز الذي نريد تعديله
    required String oldDoctorId, // ID الطبيب القديم
    required String oldSlotId, // ID الموعد القديم لتحريره
    required String newDoctorId, // ID الطبيب الجديد (قد يكون نفسه)
    required String newDoctorName, // اسم الطبيب الجديد (قد يكون نفسه)
    required String newSlotId, // ID الموعد الجديد لحجزه
  });
}
