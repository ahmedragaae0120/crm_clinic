import 'package:crm_clinic/core/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class LoginDatasource {
  Future<Result<UserCredential>> login({
    required String email,
    required String password,
  });
}
