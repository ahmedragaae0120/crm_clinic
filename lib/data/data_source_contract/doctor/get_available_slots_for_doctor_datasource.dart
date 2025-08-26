import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/doctor/available_slot_model.dart';

abstract interface class GetAvailableSlotsForDoctorDatasource {
  Future<Result<List<AvailableSlotModel>>> getAvailableSlots({
    required String doctorId,
  });
}
