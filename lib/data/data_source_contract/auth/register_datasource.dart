import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';

abstract interface class RegisterDatasource {
  Future<Result<void>> register({
    required UserModel userModel,
    required String password,
  });
}
