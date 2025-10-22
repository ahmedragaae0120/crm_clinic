import 'package:crm_clinic/core/utils/base_state.dart';

class AddPatientState {
  BaseState? addPatient;

  AddPatientState({this.addPatient});

  AddPatientState copyWith({BaseState? addPatient}) {
    return AddPatientState(addPatient: addPatient ?? this.addPatient);
  }
}
