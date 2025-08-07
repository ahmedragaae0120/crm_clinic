import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/auth/signin_with_facebook_datasource.dart';
import 'package:crm_clinic/domain/repo_contract/auth/signin_with_facebook_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SigninWithFacebookRepo)
class SigninWithFacebookRepoImpl implements SigninWithFacebookRepo {
  @factoryMethod
  SigninWithFacebookRepoImpl(this._signinWithFacebookDatasource);

  final SigninWithFacebookDatasource _signinWithFacebookDatasource;
  @override
  Future<Result<UserCredential>> signInWithFacebook() {
    return _signinWithFacebookDatasource.signInWithFacebook();
  }
}
