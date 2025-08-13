import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/add_patient_datasource.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPatientUsecase {
  @factoryMethod
  AddPatientUsecase(this._addPatientDatasource);

  final AddPatientDatasource _addPatientDatasource;
  Future<Result<void>> call(PatientModel patientModel) async =>
      await _addPatientDatasource.addPatient(patientModel);
}
