import 'package:crm_clinic/core/result.dart';

abstract interface class SignoutDatasource {
  Future<Result<void>> signOut();
}
