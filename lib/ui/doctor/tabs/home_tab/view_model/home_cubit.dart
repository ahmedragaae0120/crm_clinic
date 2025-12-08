import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/domain/use_cases/doctor/get_all_receptionist_usecase.dart';
import 'package:crm_clinic/domain/use_cases/doctor/get_today_appointments_usecase.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  @factoryMethod
  HomeCubit(this._getAllReceptionistUsecase, this._getTodayAppointmentsUsecase)
    : super(HomeState());
  final GetAllReceptionistUsecase _getAllReceptionistUsecase;
  final GetTodayAppointmentsUsecase _getTodayAppointmentsUsecase;

  getAllReceptionist() {
    final result = _getAllReceptionistUsecase.call();

    result.listen((event) {
      switch (event) {
        case Success():
          emit(
            state.copyWith(getAllReceptionist: BaseSuccessState(event.data)),
          );
        case Error():
          emit(
            state.copyWith(
              getAllReceptionist: BaseErrorState(
                event.exception.toString(),
                event.exception,
              ),
            ),
          );
      }
    });
  }

  getAppointmentsToday() {
    emit(state.copyWith(getAppointmentsToday: BaseLoadingState()));
    final result = _getTodayAppointmentsUsecase.call();
    result.listen((event) {
      switch (event) {
        case Success():
          log('Appointments Today: ${event.data}');
          emit(
            state.copyWith(
              getAppointmentsToday: BaseSuccessState(event.data ?? []),
            ),
          );
        case Error():
          emit(
            state.copyWith(
              getAppointmentsToday: BaseErrorState(
                event.exception.toString(),
                event.exception,
              ),
            ),
          );
      }
    });
  }
}
