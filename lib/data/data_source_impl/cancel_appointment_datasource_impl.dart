import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/cancel_appointment_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CancelAppointmentDatasource)
class CancelAppointmentDatasourceImpl implements CancelAppointmentDatasource {
  @factoryMethod
  CancelAppointmentDatasourceImpl(this._firebaseManager);

  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> cancelAppointment({
    required String appointmentId,
    required String doctorId,
    required String slotId,
  }) async {
    try {
      await _firebaseManager.cancelAppointment(
        appointmentId: appointmentId,
        doctorId: doctorId,
        slotId: slotId,
      );
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error(e);
    } on Exception catch (e) {
      return Error(e);
    }
  }
}
