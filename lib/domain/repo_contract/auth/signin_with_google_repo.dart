import 'package:crm_clinic/core/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class SigninWithGoogleRepo {
  Future<Result<UserCredential>> signInWithGoogle();
}
