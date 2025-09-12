import 'package:crm_clinic/core/utils/base_state.dart';

class AppointmentsState {
  BaseState? getAppointments;
  BaseState? updateAppointments;

  AppointmentsState({this.getAppointments, this.updateAppointments});

  AppointmentsState copyWith({
    BaseState? getAppointments,
    BaseState? updateAppointments,
  }) {
    return AppointmentsState(
      getAppointments: getAppointments ?? this.getAppointments,
      updateAppointments: updateAppointments ?? this.updateAppointments,
    );
  }
}
