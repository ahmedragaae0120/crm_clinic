import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/cancel_appointment_datasource.dart';
import 'package:injectable/injectable.dart';

@injectable
class CancelAppointmentUsecase {
  @factoryMethod
  CancelAppointmentUsecase(this._cancelAppointmentDatasource);
  final CancelAppointmentDatasource _cancelAppointmentDatasource;
  Future<Result<void>> call({
    required String appointmentId,
    required String doctorId,
    required String slotId,
  }) => _cancelAppointmentDatasource.cancelAppointment(
    appointmentId: appointmentId,
    doctorId: doctorId,
    slotId: slotId,
  );
}
