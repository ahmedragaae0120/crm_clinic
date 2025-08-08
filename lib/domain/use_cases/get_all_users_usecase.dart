import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/get_all_users_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllUsersUsecase {
  @factoryMethod
  GetAllUsersUsecase(this._repo);

  final GetAllUsersRepo _repo;

  Stream<Result<List<UserModel>>> call() => _repo.getAllUsers();
}
