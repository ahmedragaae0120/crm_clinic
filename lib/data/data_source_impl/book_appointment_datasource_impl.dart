import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/book_appointment_datasource.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BookAppointmentDatasource)
class BookAppointmentDatasourceImpl implements BookAppointmentDatasource {
  @factoryMethod
  BookAppointmentDatasourceImpl(this._firebaseManager);

  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> bookAppointment({
    required String patientId,
    required String doctorId,
    required String doctorName,
    required String slotId,
    required PatientModel patient,
  }) async {
    try {
      await _firebaseManager.bookAppointmentAndUpdateSlot(
        patientId: patientId,
        doctorId: doctorId,
        doctorName: doctorName,
        slotId: slotId,
        patient: patient,
      );
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error(Exception(e.message));
    } catch (error) {
      return Error(Exception(error.toString()));
    }
  }
}
