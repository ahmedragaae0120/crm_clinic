import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/domain/repo_contract/auth/login_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  @factoryMethod
  LoginUseCase(this._loginRepo);
  final LoginRepo _loginRepo;

  Future<Result<void>> call({
    required String email,
    required String password,
  }) {
    return _loginRepo.login(email: email, password: password);
  }
}
