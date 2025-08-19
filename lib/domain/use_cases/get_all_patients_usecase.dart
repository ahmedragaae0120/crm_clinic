import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/domain/repo_contract/get_all_patients_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllPatientsUsecase {
  @factoryMethod
  final GetAllPatientsRepo _getAllPatientsRepo;

  GetAllPatientsUsecase(this._getAllPatientsRepo);

  Stream<Result<List<PatientEntity>>> call() {
    return _getAllPatientsRepo.getAllPatients();
  }
}
