import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/auth/register_datasource.dart';
import 'package:crm_clinic/domain/repo_contract/auth/register_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterRepo)
class RegisterRepoImpl implements RegisterRepo {
  @factoryMethod
  RegisterRepoImpl(this._registerDatasource);

  final RegisterDatasource _registerDatasource;

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
  }) {
    return _registerDatasource.register(email: email, password: password);
  }
}
