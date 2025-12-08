import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/get_all_users_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllReceptionistUsecase {
  @factoryMethod
  GetAllReceptionistUsecase(this._getAllUsersRepo);
  final GetAllUsersRepo _getAllUsersRepo;

  Future<Result<List<UserModel>>> call() async {
    final allUsers = await _getAllUsersRepo.getAllUsers().first;
    switch (allUsers) {
      case Success<List<UserModel>>():
        final receptionists = allUsers.data
            ?.where(
              (user) => user.permission == UserPermission.receptionist.value,
            )
            .toList();
        return Success<List<UserModel>>(receptionists);
      case Error<List<UserModel>>():
        return Error<List<UserModel>>(allUsers.exception);
    }
  }
}
