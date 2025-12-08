import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';

abstract interface class GetAvailableSlotsForDoctorDatasource {
  Future<Result<List<SlotModel>>> getAvailableSlots({required String doctorId});
}
