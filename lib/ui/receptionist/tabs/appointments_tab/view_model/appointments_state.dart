import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';

class AppointmentsState {
  BaseState? getAppointments;
  BaseState? updateAppointments;
  BaseState? cancelAppointments;
  final List<AppointmentModel>? appointmentsList;

  AppointmentsState({
    this.getAppointments,
    this.updateAppointments,
    this.cancelAppointments,
    this.appointmentsList = const [],
  });

  AppointmentsState copyWith({
    BaseState? getAppointments,
    BaseState? updateAppointments,
    BaseState? cancelAppointments,
    List<AppointmentModel>? appointmentsList,
  }) {
    return AppointmentsState(
      getAppointments: getAppointments ?? this.getAppointments,
      updateAppointments: updateAppointments ?? this.updateAppointments,
      cancelAppointments: cancelAppointments ?? this.cancelAppointments,
      appointmentsList: appointmentsList ?? this.appointmentsList,
    );
  }
}
