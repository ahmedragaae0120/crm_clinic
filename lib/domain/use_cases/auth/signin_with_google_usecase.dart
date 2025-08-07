import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/domain/repo_contract/auth/signin_with_google_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class SigninWithGoogleUsecase {
  @factoryMethod
  SigninWithGoogleUsecase(this._signinWithGoogleRepo);
  final SigninWithGoogleRepo _signinWithGoogleRepo;

  Future<Result<UserCredential>> call() =>
      _signinWithGoogleRepo.signInWithGoogle();
}
