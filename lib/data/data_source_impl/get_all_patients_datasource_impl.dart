import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_patients_datasource.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAllPatientsDatasource)
class GetAllPatientsDatasourceImpl implements GetAllPatientsDatasource {
  @factoryMethod
  GetAllPatientsDatasourceImpl(this._firebaseManager);

  final FirebaseManager _firebaseManager;
  @override
  Stream<Result<List<PatientModel>>> getAllPatients() {
    try {
      var snapshot = _firebaseManager.getAllDocsInCollection(
        Collections.patients,
      );
      return snapshot.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<PatientModel> patients = snapshot.docs
              .map((doc) => PatientModel.fromJson(doc.data()))
              .toList();
          return Success(patients);
        } else {
          return Error(Exception('no patients found'));
        }
      });
    } on FirebaseException catch (e) {
      return Stream.value(Error(Exception(e)));
    } catch (e) {
      return Stream.value(Error(Exception(e)));
    }
  }
}
