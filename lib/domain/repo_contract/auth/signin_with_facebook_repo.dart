import 'package:crm_clinic/core/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SigninWithFacebookRepo {
  Future<Result<UserCredential>> signInWithFacebook();
}
