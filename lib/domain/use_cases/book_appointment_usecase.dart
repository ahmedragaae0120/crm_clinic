import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/book_appointment_datasource.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookAppointmentUsecase {
  final BookAppointmentDatasource _bookAppointmentDatasource;
  BookAppointmentUsecase(this._bookAppointmentDatasource);

  Future<Result<void>> call({
    required String patientId,
    required String doctorId,
    required String slotId,
    required PatientModel patient,
  }) async => await _bookAppointmentDatasource.bookAppointment(
    patientId: patientId,
    doctorId: doctorId,
    slotId: slotId,
    patient: patient,
  );
}
