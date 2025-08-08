import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_users_datasource.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/repo_contract/get_all_users_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAllUsersRepo)
class GetAllUsersRepoImpl implements GetAllUsersRepo {
  @factoryMethod
  GetAllUsersRepoImpl(this._getAllUsersDatasource);
  final GetAllUsersDatasource _getAllUsersDatasource;

  @override
  Stream<Result<List<UserModel>>> getAllUsers() {
    return _getAllUsersDatasource.getAllUsers();
  }
}
