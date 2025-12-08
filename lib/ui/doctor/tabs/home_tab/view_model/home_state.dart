part of 'home_cubit.dart';

class HomeState {
  BaseState? getAllReceptionist;
  BaseState? getAppointmentsToday;

  HomeState({this.getAllReceptionist, this.getAppointmentsToday});

  HomeState copyWith({
    BaseState? getAllReceptionist,
    BaseState? getAppointmentsToday,
  }) {
    return HomeState(
      getAllReceptionist: getAllReceptionist ?? this.getAllReceptionist,
      getAppointmentsToday: getAppointmentsToday ?? this.getAppointmentsToday,
    );
  }
}
