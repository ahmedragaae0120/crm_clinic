import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_users_datasource.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAllUsersDatasource)
class GetAllUsersDatasourceImpl implements GetAllUsersDatasource {
  @factoryMethod
  GetAllUsersDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;

  @override
  Stream<Result<List<UserModel>>> getAllUsers() {
    try {
      var snapshot = _firebaseManager.getAllDocsInCollection(Collections.users);
      return snapshot.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<UserModel> usersList = snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .toList();
          return Success(usersList);
        } else {
          return Error(Exception('no users found'));
        }
      });
    } on FirebaseException catch (e) {
      return Stream.value(Error(Exception(e)));
    } catch (e) {
      return Stream.value(Error(Exception(e)));
    }
  }
}
