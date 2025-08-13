import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/add_patient_datasource.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddPatientDatasource)
class AddPatientDatasourceImpl implements AddPatientDatasource {
  @factoryMethod
  AddPatientDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> addPatient(PatientModel patientModel) async {
    try {
      await _firebaseManager.addPatient(patientModel);
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error(Exception(e));
    } catch (error) {
      return Error(Exception(error));
    }
  }
}
