import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/auth/register_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterDatasource)
class RegisterDatasourceImpl implements RegisterDatasource {
  @factoryMethod
  RegisterDatasourceImpl(this._firebaseManager);

  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> register(
      {required String email, required String password}) async {
    try {
      await _firebaseManager.registerService(email, password);
      return Success<void>(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Error(Exception('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return Error(Exception('The account already exists for that email.'));
      } else {
        return Error(Exception('Registration error: ${e.message}'));
      }
    } catch (e) {
      return Error(Exception(e));
    }
  }
}
