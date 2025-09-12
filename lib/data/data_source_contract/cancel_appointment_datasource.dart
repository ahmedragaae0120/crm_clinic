import 'package:crm_clinic/core/result.dart';

abstract interface class CancelAppointmentDatasource {
  Future<Result<void>> cancelAppointment({
    required String appointmentId,
    required String doctorId,
    required String slotId,
  });
}
