import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/add_available_slots_for_doctor_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddAvailableSlotsForDoctorDatasource)
class AddAvailableSlotsForDoctorDatasourceImpl
    implements AddAvailableSlotsForDoctorDatasource {
  @factoryMethod
  AddAvailableSlotsForDoctorDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;
  @override
  Future<Result<void>> addAvailableSlots({
    required String doctorId,
    required List<DateTime> slots,
  }) async {
    try {
      await _firebaseManager.addAvailableSlotsForDoctor(
        doctorId: doctorId,
        slots: slots,
      );
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error(Exception(e.message));
    } catch (error) {
      return Error(Exception(error.toString()));
    }
  }
}
