import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/auth/signout_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SignoutDatasource)
class SignoutDatasourceImpl implements SignoutDatasource {
  @factoryMethod
  SignoutDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> signOut() async {
    try {
      await _firebaseManager.signOut();
      return Success<void>(null);
    } on FirebaseAuthException catch (e) {
      return Error(Exception(e));
    } catch (error) {
      return Error(Exception(error));
    }
  }
}
