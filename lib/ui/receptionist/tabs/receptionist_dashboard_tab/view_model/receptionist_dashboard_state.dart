part of 'receptionist_dashboard_cubit.dart';

class ReceptionistDashboardState {
  BaseState? getPatients;
  BaseState? getDoctors;
  BaseState? getSlots;
  BaseState? bookAppointment;
  final List<PatientEntity> allPatients; // 1. أضف هذه للاحتفاظ بالقائمة الكاملة
  final List<UserModel> allDoctors; // قائمة الأطباء

  ReceptionistDashboardState({
    this.getPatients,
    this.getDoctors,
    this.getSlots,
    this.bookAppointment,
    this.allPatients = const [],
    this.allDoctors = const [],
  });

  ReceptionistDashboardState copyWith({
    BaseState? getPatients,
    BaseState? getDoctors,
    BaseState? getSlots,
    BaseState? bookAppointment,
    List<PatientEntity>? allPatients,
    List<UserModel>? allDoctors,
  }) {
    return ReceptionistDashboardState(
      getPatients: getPatients ?? this.getPatients,
      getDoctors: getDoctors ?? this.getDoctors,
      getSlots: getSlots ?? this.getSlots,
      bookAppointment: bookAppointment ?? this.bookAppointment,
      allPatients: allPatients ?? this.allPatients,
      allDoctors: allDoctors ?? this.allDoctors,
    );
  }
}
