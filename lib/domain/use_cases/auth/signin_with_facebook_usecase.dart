import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/domain/repo_contract/auth/signin_with_facebook_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class SigninWithFacebookUsecase {
  @factoryMethod
  SigninWithFacebookUsecase(this._signinWithFacebookRepo);

  final SigninWithFacebookRepo _signinWithFacebookRepo;

  Future<Result<UserCredential>> call() =>
      _signinWithFacebookRepo.signInWithFacebook();
}
