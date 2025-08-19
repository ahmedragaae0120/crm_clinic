import 'package:crm_clinic/core/result.dart';

abstract interface class RemoveDocDatasource {
  Future<Result<void>> removeDoc({required String id});
}
