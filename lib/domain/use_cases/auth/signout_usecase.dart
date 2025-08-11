import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/auth/signout_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignoutUsecase {
  @factoryMethod
  SignoutUsecase(this._signoutDatasource);
  final SignoutDatasource _signoutDatasource;

  Future<Result<void>> call() async => await _signoutDatasource.signOut();
}
