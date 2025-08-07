import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/auth/signin_with_google_datasource.dart';
import 'package:crm_clinic/domain/repo_contract/auth/signin_with_google_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SigninWithGoogleRepo)
class SigninWithGoogleRepoImpl implements SigninWithGoogleRepo {
  @factoryMethod
  SigninWithGoogleRepoImpl(this._signinWithGoogleDatasource);
  final SigninWithGoogleDatasource _signinWithGoogleDatasource;
  @override
  Future<Result<UserCredential>> signInWithGoogle() {
    return _signinWithGoogleDatasource.signInWithGoogle();
  }
}
