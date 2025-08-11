import 'package:crm_clinic/core/result.dart';

abstract interface class CreateAdminEmailDatasource {
  Future<Result<void>> createDefaultAdminIfNotExists();
}
