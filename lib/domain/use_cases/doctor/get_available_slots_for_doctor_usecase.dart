import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/get_available_slots_for_doctor_datasource.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAvailableSlotsForDoctorUsecase {
  @factoryMethod
  GetAvailableSlotsForDoctorUsecase(this.datasource);
  final GetAvailableSlotsForDoctorDatasource datasource;

  Future<Result<List<SlotModel>>> call({required String doctorId}) {
    return datasource.getAvailableSlots(doctorId: doctorId);
  }
}
