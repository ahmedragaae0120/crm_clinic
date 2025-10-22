import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_doctors_datasource.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAllDoctorsDatasource)
class GetAllDoctorsDatasourceImpl implements GetAllDoctorsDatasource {
  @factoryMethod
  GetAllDoctorsDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;
  @override
  Future<Result<List<UserModel>>> getAllDoctors() async {
    try {
      var snapshot = await _firebaseManager.getDoctors();
      if (snapshot.docs.isNotEmpty) {
        List<UserModel> doctorList = snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList();
        return Success(doctorList);
      } else {
        return Error(Exception('no doctors found'));
      }
    } on FirebaseException catch (e) {
      return Error(Exception(e));
    } catch (e) {
      return Error(Exception(e));
    }
  }
}
