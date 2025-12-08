import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_appointments_datasource.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTodayAppointmentsUsecase {
  @factoryMethod
  GetTodayAppointmentsUsecase(this._getAllAppointmentsDatasource);
  final GetAllAppointmentsDatasource _getAllAppointmentsDatasource;

  Stream<Result<List<AppointmentModel>>> call() {
    final today = DateTime.now();
    return _getAllAppointmentsDatasource.getAllAppointments().map((result) {
      switch (result) {
        case Success<List<AppointmentModel>>():
          final todayAppointments = result.data?.where((appointment) {
            final date = appointment.dateTime;
            if (date == null) return false;
            return date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
          }).toList();
          return Success<List<AppointmentModel>>(todayAppointments);

        case Error<List<AppointmentModel>>():
          return Error<List<AppointmentModel>>(result.exception);
      }
    });
  }
}
