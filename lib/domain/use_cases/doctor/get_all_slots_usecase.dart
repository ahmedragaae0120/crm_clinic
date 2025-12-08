import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/get_all_slots_by_doctor_datasource.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllSlotsUsecase {
  @factoryMethod
  GetAllSlotsUsecase(this.getAllSlotsByDoctorDatasource);
  final GetAllSlotsByDoctorDatasource getAllSlotsByDoctorDatasource;

  Stream<Result<List<SlotModel>>> call({required String doctorId}) =>
      getAllSlotsByDoctorDatasource.getAllSlotsByDoctor(doctorId: doctorId);
}
