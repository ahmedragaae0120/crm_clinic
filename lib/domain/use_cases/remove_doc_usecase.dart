import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/remove_doc_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveDocUsecase {
  @factoryMethod
  RemoveDocUsecase(this._removeDocDatasource);

  final RemoveDocDatasource _removeDocDatasource;
  Future<Result<void>> call({required String id}) =>
      _removeDocDatasource.removeDoc(id: id);
}
