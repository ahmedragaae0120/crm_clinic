import 'dart:developer';

import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/get_all_users_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllReceptionistUsecase {
  @factoryMethod
  GetAllReceptionistUsecase(this._getAllUsersRepo);
  final GetAllUsersRepo _getAllUsersRepo;

  Stream<Result<List<UserModel>>> call() {
    final allUsers = _getAllUsersRepo.getAllUsers();

    return allUsers.map((user) {
      switch (user) {
        case Success<List<UserModel>>():
          final receptionist = user.data
              ?.where(
                (user) => user.permission == UserPermission.receptionist.value,
              )
              .toList();
          return Success<List<UserModel>>(receptionist);
        case Error<List<UserModel>>():
          return Error<List<UserModel>>(user.exception);
      }
    });
  }
}
