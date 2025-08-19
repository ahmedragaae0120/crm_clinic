import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';

abstract interface class GetAllPatientsRepo {
  Stream<Result<List<PatientEntity>>> getAllPatients();
}
