import 'package:crm_clinic/core/result.dart';

abstract interface class RemoveUserDatasource {
  Future<Result<void>> removeUser(String userId);
}
