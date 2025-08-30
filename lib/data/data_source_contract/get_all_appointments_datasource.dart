import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';

abstract interface class GetAllAppointmentsDatasource {
  Stream<Result<List<AppointmentModel>>> getAllAppointments();
}
