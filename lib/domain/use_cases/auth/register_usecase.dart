import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/auth/register_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUsecase {
  @factoryMethod
  RegisterUsecase(this._registerRepo);
  final RegisterRepo _registerRepo;

  Future<Result<void>> call(
      {required UserModel userModel, required String password}) async {
    return await _registerRepo.register(
        userModel: userModel, password: password);
  }
}
