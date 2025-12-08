import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/data_source_contract/get_all_appointments_datasource.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllAppointmentsUsecase {
  @factoryMethod
  GetAllAppointmentsUsecase(this._getAllAppointmentsDatasource);
  final GetAllAppointmentsDatasource _getAllAppointmentsDatasource;

  Stream<Result<List<AppointmentModel>>> call() =>
      _getAllAppointmentsDatasource.getAllAppointments();
}
