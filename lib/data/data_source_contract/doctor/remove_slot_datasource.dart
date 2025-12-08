import 'package:crm_clinic/core/result.dart';

abstract interface class RemoveSlotDataSource {
  Future<Result<void>> removeSlot({
    required String doctorId,
    required String slotId,
  });
}
