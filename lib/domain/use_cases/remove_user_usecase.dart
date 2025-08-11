import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/remove_user_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveUserUsecase {
  @factoryMethod
  RemoveUserUsecase(this.removeUserDatasource);
  RemoveUserDatasource removeUserDatasource;

  Future<Result<void>> call(String userId) async =>
      await removeUserDatasource.removeUser(userId);
}
