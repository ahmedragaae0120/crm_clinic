import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/add_user_datasource.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddUserDatasource)
class AddUserDatasourceImpl implements AddUserDatasource {
  @factoryMethod
  AddUserDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;
  @override
  Future<Result<void>> addUser(
      UserModel userModel, UserCredential userCredential) async {
    try {
      await _firebaseManager.addUser(
          userModel: userModel, userCredential: userCredential);
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error(Exception(e));
    } catch (e) {
      return Error(Exception(e));
    }
  }
}
