import 'package:crm_clinic/core/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class SigninWithFacebookDatasource {
  Future<Result<UserCredential>> signInWithFacebook();
}
