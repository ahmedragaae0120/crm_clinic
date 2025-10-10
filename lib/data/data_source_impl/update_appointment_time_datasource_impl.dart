import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/update_appointment_time_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UpdateAppointmentTimeDatasource)
class UpdateAppointmentTimeDatasourceImpl
    implements UpdateAppointmentTimeDatasource {
  @factoryMethod
  UpdateAppointmentTimeDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> updateAppointmentTime({
    required String appointmentId, // ID الحجز الذي نريد تعديله
    required String oldDoctorId, // ID الطبيب القديم
    required String oldSlotId, // ID الموعد القديم لتحريره
    required String newDoctorId, // ID الطبيب الجديد (قد يكون نفسه)
    required String newDoctorName, // اسم الطبيب الجديد (قد يكون نفسه)
    required String newSlotId, // ID الموعد الجديد لحجزه
  }) async {
    try {
      await _firebaseManager.updateAppointment(
        appointmentId: appointmentId,
        oldDoctorId: oldDoctorId,
        oldSlotId: oldSlotId,
        newDoctorId: newDoctorId,
        newDoctorName: newDoctorName,
        newSlotId: newSlotId,
      );
      return Success<void>(null);
    } on FirebaseException catch (error) {
      return Error(Exception(error.message));
    } catch (error) {
      return Error(Exception(error));
    }
  }
}
