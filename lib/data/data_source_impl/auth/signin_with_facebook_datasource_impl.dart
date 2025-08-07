import 'dart:developer';

import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/auth/signin_with_facebook_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SigninWithFacebookDatasource)
class SigninWithFacebookDatasourceImpl implements SigninWithFacebookDatasource {
  @factoryMethod
  SigninWithFacebookDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;
  @override
  Future<Result<UserCredential>> signInWithFacebook() async {
    try {
      final result = await _firebaseManager.signInWithFacebook();
      log("Success💚");
      return Success(result);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return Error(Exception(e));
    } catch (e) {
      log(e.toString());
      return Error(Exception(e));
    }
  }
}
