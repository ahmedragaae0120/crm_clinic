import 'dart:developer';

import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/auth/signin_with_google_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SigninWithGoogleDatasource)
class SigninWithGoogleDatasourceImpl implements SigninWithGoogleDatasource {
  @factoryMethod
  SigninWithGoogleDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;

  @override
  Future<Result<UserCredential>> signInWithGoogle() async {
    try {
      final response = await _firebaseManager.signInWithGoogle();
      return Success(response);
    } catch (error) {
      log(error.toString());
      return Error(Exception(error));
    }
  }
}
