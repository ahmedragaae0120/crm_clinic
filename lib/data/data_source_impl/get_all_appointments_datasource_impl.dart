import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_appointments_datasource.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GetAllAppointmentsDatasource)
class GetAllAppointmentsDatasourceImpl implements GetAllAppointmentsDatasource {
  GetAllAppointmentsDatasourceImpl(this._firebaseManager);
  final FirebaseManager _firebaseManager;
  @override
  Stream<Result<List<AppointmentModel>>> getAllAppointments() {
    try {
      var response = _firebaseManager.getAllDocsInCollection(
        Collections.appointments,
      );
      return response.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<AppointmentModel> appointments = snapshot.docs
              .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
              .toList();
          return Success(appointments);
        } else {
          return Error(Exception('no appointments found'));
        }
      });
    } on FirebaseException catch (e) {
      return Stream.value(Error(Exception(e)));
    } catch (error) {
      return Stream.value(Error(Exception(error)));
    }
  }
}
