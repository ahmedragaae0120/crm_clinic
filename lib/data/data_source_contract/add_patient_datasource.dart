import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/patient_model.dart';

abstract interface class AddPatientDatasource {
  Future<Result<void>> addPatient(PatientModel patientModel);
}
