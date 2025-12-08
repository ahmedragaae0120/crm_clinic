import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/add_slots_for_doctor_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddSlotsForDoctorDatasource)
class AddSlotsForDoctorDatasourceImpl implements AddSlotsForDoctorDatasource {
  @factoryMethod
  AddSlotsForDoctorDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;
  @override
  Future<Result<void>> addSlot({
    required String doctorId,
    required DateTime slot,
  }) async {
    try {
      await _firebaseManager.addSlotForDoctor(doctorId: doctorId, slot: slot);
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error(Exception(e.message));
    } catch (error) {
      return Error(Exception(error.toString()));
    }
  }
}
