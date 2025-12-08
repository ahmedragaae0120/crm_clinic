import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/get_all_slots_by_doctor_datasource.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAllSlotsByDoctorDatasource)
class GetAllSlotsByDoctorDatasourceImpl
    implements GetAllSlotsByDoctorDatasource {
  @factoryMethod
  GetAllSlotsByDoctorDatasourceImpl(this.firebaseManager);
  final FirebaseManager firebaseManager;
  @override
  Stream<Result<List<SlotModel>>> getAllSlotsByDoctor({
    required String doctorId,
  }) {
    try {
      var response = firebaseManager.getAllSlotsByDoctor(
        doctorId,
      ); // Remember chaned collection name,🔔🔔🔔🔔🔔🔔
      return response.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<SlotModel> slots = snapshot.docs
              .map((doc) => SlotModel.fromJson(doc.data(), doc.id))
              .toList();
          return Success<List<SlotModel>>(slots);
        } else {
          return Error(Exception('no slots found'));
        }
      });
    } on FirebaseException catch (e) {
      return Stream.value(Error(Exception(e)));
    } catch (error) {
      return Stream.value(Error(Exception(error)));
    }
  }
}
