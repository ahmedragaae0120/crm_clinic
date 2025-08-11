import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/auth/create_admin_email_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateAdminEmailUsecase {
  final CreateAdminEmailDatasource _createAdminEmailDatasource;
  @factoryMethod
  CreateAdminEmailUsecase(this._createAdminEmailDatasource);

  Future<Result<void>> call() =>
      _createAdminEmailDatasource.createDefaultAdminIfNotExists();
}
