import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';

abstract interface class GetAllSlotsByDoctorDatasource {
  Stream<Result<List<SlotModel>>> getAllSlotsByDoctor({
    required String doctorId,
  });
}
