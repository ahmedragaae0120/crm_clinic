import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';

class ReceptionistState {
  BaseState? getAppointments;

  ReceptionistState({this.getAppointments});

  ReceptionistState copyWith({
    BaseState? getPatients,
    BaseState? getDoctors,
    BaseState? getAppointments,
    BaseState? getSlots,
    BaseState? bookAppointment,
    List<PatientEntity>? allPatients,
    List<UserModel>? allDoctors,
  }) {
    return ReceptionistState(
      getAppointments: getAppointments ?? this.getAppointments,
    );
  }
}
