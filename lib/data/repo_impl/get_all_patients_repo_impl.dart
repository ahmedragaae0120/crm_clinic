import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_patients_datasource.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/domain/repo_contract/get_all_patients_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAllPatientsRepo)
class GetAllPatientsRepoImpl implements GetAllPatientsRepo {
  @factoryMethod
  GetAllPatientsRepoImpl(this._getAllPatientsDatasource);

  final GetAllPatientsDatasource _getAllPatientsDatasource;

  @override
  Stream<Result<List<PatientEntity>>> getAllPatients() {
    return _getAllPatientsDatasource.getAllPatients().map((result) {
      switch (result) {
        case Success<List<PatientModel>>():
          final entities = result.data?.map((e) => e.toDomainDTO()).toList();
          return Success<List<PatientEntity>>(entities);
        case Error():
          return Error<List<PatientEntity>>(result.exception);
      }
    });
  }
}
