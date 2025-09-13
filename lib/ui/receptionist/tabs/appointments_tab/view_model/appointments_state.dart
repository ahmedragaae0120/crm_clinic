import 'package:crm_clinic/core/utils/base_state.dart';

class AppointmentsState {
  BaseState? getAppointments;
  BaseState? updateAppointments;
  BaseState? cancelAppointments;

  AppointmentsState({
    this.getAppointments,
    this.updateAppointments,
    this.cancelAppointments,
  });

  AppointmentsState copyWith({
    BaseState? getAppointments,
    BaseState? updateAppointments,
    BaseState? cancelAppointments,
  }) {
    return AppointmentsState(
      getAppointments: getAppointments ?? this.getAppointments,
      updateAppointments: updateAppointments ?? this.updateAppointments,
      cancelAppointments: cancelAppointments ?? this.cancelAppointments,
    );
  }
}
