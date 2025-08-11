import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/auth/login_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginDatasource)
class LoginDatasourceImpl implements LoginDatasource {
  @factoryMethod
  LoginDatasourceImpl(this._firebaseManager);

  final FirebaseManager _firebaseManager;

  @override
  Future<Result<UserCredential>> login(
      {required String email, required String password}) async {
    try {
      final response = await _firebaseManager.loginService(email, password);
      return Success<UserCredential>(response);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Error(Exception('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return Error(Exception('Wrong password provided for that user.'));
      } else {
        return Error(Exception('Authentication error: ${e.message}'));
      }
    } catch (e) {
      return Error(Exception(e));
    }
  }
}
