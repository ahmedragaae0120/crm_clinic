import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/update_appointment_time_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAppointmentTimeUsecase {
  @factoryMethod
  UpdateAppointmentTimeUsecase(this._updateAppointmentTimeDatasource);
  final UpdateAppointmentTimeDatasource _updateAppointmentTimeDatasource;

  Future<Result<void>> call({
    required String appointmentId, // ID الحجز الذي نريد تعديله
    required String oldDoctorId, // ID الطبيب القديم
    required String oldSlotId, // ID الموعد القديم لتحريره
    required String newDoctorId, // ID الطبيب الجديد (قد يكون نفسه)
    required String newDoctorName, // اسم الطبيب الجديد (قد يكون نفسه)
    required String newSlotId, // ID الموعد الجديد لحجزه
  }) => _updateAppointmentTimeDatasource.updateAppointmentTime(
    appointmentId: appointmentId,
    oldDoctorId: oldDoctorId,
    oldSlotId: oldSlotId,
    newDoctorId: newDoctorId,
    newDoctorName: newDoctorName,
    newSlotId: newSlotId,
  );
}
