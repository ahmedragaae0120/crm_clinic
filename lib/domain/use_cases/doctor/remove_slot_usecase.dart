import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/remove_slot_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveSlotUseCase {
  final RemoveSlotDataSource _removeSlotDataSource;
  @factoryMethod
  RemoveSlotUseCase(this._removeSlotDataSource);

  Future<Result<void>> call({
    required String doctorId,
    required String slotId,
  }) {
    return _removeSlotDataSource.removeSlot(doctorId: doctorId, slotId: slotId);
  }
}
