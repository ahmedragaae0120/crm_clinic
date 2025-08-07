import 'package:crm_clinic/core/result.dart';

abstract interface class RegisterRepo {
  Future<Result<void>> register({
    required String email,
    required String password,
  });
}
