import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/add_user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddUserUsecase {
  @factoryMethod
  AddUserUsecase(this._addUserRepo);
  final AddUserRepo _addUserRepo;

  Future<Result<void>> call(
          UserModel userModel, UserCredential userCredential) async =>
      await _addUserRepo.addUser(userModel, userCredential);
}
