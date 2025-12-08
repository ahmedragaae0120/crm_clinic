import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/add_slots_for_doctor_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddSlotsForDoctorUsecase {
  @factoryMethod
  AddSlotsForDoctorUsecase(this.datasource);
  final AddSlotsForDoctorDatasource datasource;

  Future<Result<void>> call({
    required String doctorId,
    required DateTime slot,
  }) {
    return datasource.addSlot(doctorId: doctorId, slot: slot);
  }
}
