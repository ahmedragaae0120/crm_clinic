import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/get_available_slots_for_doctor_datasource.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAvailableSlotsForDoctorDatasource)
class GetAvailableSlotsForDoctorDatasourceImpl
    implements GetAvailableSlotsForDoctorDatasource {
  @factoryMethod
  GetAvailableSlotsForDoctorDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;
  @override
  Future<Result<List<SlotModel>>> getAvailableSlots({
    required String doctorId,
  }) async {
    try {
      final querySnapshot = await _firebaseManager.getAvailableSlotsForDoctor(
        doctorId,
      );
      final slots = querySnapshot.docs
          .map((doc) => SlotModel.fromJson(doc.data(), doc.id))
          .toList();

      log("slots: ${slots.length}");
      if (slots.isNotEmpty) {
        return Success<List<SlotModel>>(slots);
      } else {
        return Error(Exception("no slots found"));
      }
    } on FirebaseException catch (e) {
      log(e.message.toString());
      return Error(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return Error(Exception(e.toString()));
    }
  }
}
