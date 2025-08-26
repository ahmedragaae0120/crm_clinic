import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';

class ReceptionistState {
  BaseState? addPatient;
  BaseState? getPatients;
  BaseState? getDoctors;
  final List<PatientEntity> allPatients; // 1. أضف هذه للاحتفاظ بالقائمة الكاملة
  final List<UserModel> allDoctors; // قائمة الأطباء
  ReceptionistState({
    this.addPatient,
    this.getPatients,
    this.getDoctors,
    this.allPatients = const [],
    this.allDoctors = const [],
  });

  ReceptionistState copyWith({
    BaseState? addPatient,
    BaseState? getPatients,
    BaseState? getDoctors,
    List<PatientEntity>? allPatients,
    List<UserModel>? allDoctors,
  }) {
    return ReceptionistState(
      addPatient: addPatient ?? this.addPatient,
      getPatients: getPatients ?? this.getPatients,
      getDoctors: getDoctors ?? this.getDoctors,
      allPatients: allPatients ?? this.allPatients,
      allDoctors: allDoctors ?? this.allDoctors,
    );
  }
}
