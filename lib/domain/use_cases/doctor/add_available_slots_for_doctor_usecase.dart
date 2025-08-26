import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/add_available_slots_for_doctor_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddAvailableSlotsForDoctorUsecase {
  @factoryMethod
  AddAvailableSlotsForDoctorUsecase(this.datasource);
  final AddAvailableSlotsForDoctorDatasource datasource;

  Future<Result<void>> call({
    required String doctorId,
    required List<DateTime> slots,
  }) {
    return datasource.addAvailableSlots(doctorId: doctorId, slots: slots);
  }
}
