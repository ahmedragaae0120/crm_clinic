import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AddUserRepo {
  Future<Result<void>> addUser(
      UserModel userModel, UserCredential userCredential);
}
