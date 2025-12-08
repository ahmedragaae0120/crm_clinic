import 'package:crm_clinic/core/result.dart';

abstract interface class AddSlotsForDoctorDatasource {
  Future<Result<void>> addSlot({
    required String doctorId,
    required DateTime slot,
  });
}
