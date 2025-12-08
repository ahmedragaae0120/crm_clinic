import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';

abstract interface class RegisterRepo {
  Future<Result<void>> register({
    required UserModel userModel,
    required String password,
  });
}
