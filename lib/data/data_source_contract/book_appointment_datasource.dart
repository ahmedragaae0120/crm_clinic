import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/patient_model.dart';

abstract interface class BookAppointmentDatasource {
  Future<Result<void>> bookAppointment({
    required String patientId,
    required String doctorId,
    required String doctorName,
    required String slotId,
    required PatientModel patient,
  });
}
