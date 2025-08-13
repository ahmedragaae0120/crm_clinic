import 'package:crm_clinic/core/utils/base_state.dart';

class ReceptionistState {
  BaseState? addPatient;

  ReceptionistState({this.addPatient});

  ReceptionistState copyWith({BaseState? addPatient}) {
    return ReceptionistState(addPatient: addPatient ?? this.addPatient);
  }
}
