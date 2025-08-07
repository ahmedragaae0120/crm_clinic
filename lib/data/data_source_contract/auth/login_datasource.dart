import 'package:crm_clinic/core/result.dart';

abstract interface class LoginDatasource {
  Future<Result<void>> login({
    required String email,
    required String password,
  });
}
