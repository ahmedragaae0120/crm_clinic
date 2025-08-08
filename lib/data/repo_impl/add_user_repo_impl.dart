import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/add_user_datasource.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/add_user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddUserRepo)
class AddUserRepoImpl implements AddUserRepo {
  @factoryMethod
  AddUserRepoImpl(this._addUserDatasource);
  final AddUserDatasource _addUserDatasource;

  @override
  Future<Result<void>> addUser(
      UserModel userModel, UserCredential userCredential) async {
    return await _addUserDatasource.addUser(userModel, userCredential);
  }
}
