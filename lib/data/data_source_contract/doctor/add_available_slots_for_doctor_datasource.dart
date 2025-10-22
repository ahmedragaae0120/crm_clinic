import 'package:crm_clinic/core/result.dart';

abstract interface class AddAvailableSlotsForDoctorDatasource {
  Future<Result<void>> addAvailableSlots({
    required String doctorId,
    required List<DateTime> slots,
  });
}
