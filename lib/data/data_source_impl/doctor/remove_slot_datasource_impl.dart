import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/doctor/remove_slot_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RemoveSlotDataSource)
class RemoveSlotDataSourceImpl implements RemoveSlotDataSource {
  final FirebaseManager _firebaseManager;
  @factoryMethod
  RemoveSlotDataSourceImpl(this._firebaseManager);

  @override
  Future<Result<void>> removeSlot({
    required String doctorId,
    required String slotId,
  }) async {
    try {
      await _firebaseManager.removeSlot(doctorId: doctorId, slotId: slotId);
      return Success<void>(null);
    } on FirebaseException catch (e) {
      return Error(Exception(e.message));
    } catch (error) {
      return Error(Exception(error.toString()));
    }
  }
}
