import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/remove_doc_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RemoveDocDatasource)
class RemoveDocDatasourceImpl implements RemoveDocDatasource {
  @factoryMethod
  RemoveDocDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;

  @override
  Future<Result<void>> removeDoc({required String id}) async {
    try {
      await _firebaseManager.removeDoc(
        collection: Collections.patients,
        id: id,
      );
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error<void>(Exception("${e.message}"));
    } on Exception catch (error) {
      return Error<void>(Exception("Error removing document: $error"));
    }
  }
}
