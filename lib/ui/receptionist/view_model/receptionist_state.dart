import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';

class ReceptionistState {
  BaseState? addPatient;
  BaseState? getPatients;
  final List<PatientEntity> allPatients; // 1. أضف هذه للاحتفاظ بالقائمة الكاملة

  ReceptionistState({
    this.addPatient,
    this.getPatients,
    this.allPatients = const [],
  });

  ReceptionistState copyWith({
    BaseState? addPatient,
    BaseState? getPatients,
    List<PatientEntity>? allPatients,
  }) {
    return ReceptionistState(
      addPatient: addPatient ?? this.addPatient,
      getPatients: getPatients ?? this.getPatients,
      allPatients: allPatients ?? this.allPatients,
    );
  }
}
