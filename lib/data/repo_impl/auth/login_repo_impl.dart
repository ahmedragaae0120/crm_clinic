import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/auth/login_datasource.dart';
import 'package:crm_clinic/domain/repo_contract/auth/login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepo)
class LoginRepoImpl implements LoginRepo {
  @factoryMethod
  LoginRepoImpl(this._loginDatasource);

  final LoginDatasource _loginDatasource;

  @override
  Future<Result<UserCredential>> login({
    required String email,
    required String password,
  }) {
    return _loginDatasource.login(email: email, password: password);
  }
}
