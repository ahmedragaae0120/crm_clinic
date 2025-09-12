import 'dart:developer';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/domain/use_cases/get_all_appointments_usecase.dart';
import 'package:crm_clinic/domain/use_cases/update_appointment_time_usecase.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppointmentsCubit extends Cubit<AppointmentsState> {
  @factoryMethod
  AppointmentsCubit(
    this._getAllAppointmentsUsecase,
    this._updateAppointmentTimeDatasource,
  ) : super(AppointmentsState());
  final GetAllAppointmentsUsecase _getAllAppointmentsUsecase;
  final UpdateAppointmentTimeUsecase _updateAppointmentTimeDatasource;

  // Future<void> cancelAppointment(String id) async {
  //   try {
  //     await _firebaseManager.cancelAppointment(id);
  //     getAllAppointment();
  //   } catch (e) {
  //     log('Error canceling appointment: $e');
  //   }
  // }

  static AppointmentsCubit get(context) => BlocProvider.of(context);

  Future<void> updateAppointmentTime({
    required String appointmentId, // ID الحجز الذي نريد تعديله
    required String oldDoctorId, // ID الطبيب القديم
    required String oldSlotId, // ID الموعد القديم لتحريره
    required String newDoctorId, // ID الطبيب الجديد (قد يكون نفسه)
    required String newSlotId, // ID الموعد الجديد لحجزه
  }) async {
    emit(state.copyWith(updateAppointments: BaseLoadingState()));
    final result = await _updateAppointmentTimeDatasource.call(
      appointmentId: appointmentId,
      oldDoctorId: oldDoctorId,
      oldSlotId: oldSlotId,
      newDoctorId: newDoctorId,
      newSlotId: newSlotId,
    );
    switch (result) {
      case Success():
        emit(state.copyWith(updateAppointments: BaseSuccessState(null)));
        break;
      case Error():
        emit(
          state.copyWith(
            updateAppointments: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
        log(result.exception.toString());
        break;
    }
  }

  void getAllAppointment() {
    emit(state.copyWith(getAppointments: BaseLoadingState()));
    _getAllAppointmentsUsecase.call().listen((appointments) {
      if (appointments is Success<List<AppointmentModel>>) {
        final appointmentList = appointments.data ?? [];
        log('Appointments fetched successfully: ${appointments.data?.length}');
        emit(
          state.copyWith(getAppointments: BaseSuccessState(appointmentList)),
        );
      } else if (appointments is Error<List<AppointmentModel>>) {
        emit(
          state.copyWith(
            getAppointments: BaseErrorState(
              appointments.exception.toString(),
              appointments.exception,
            ),
          ),
        );
      }
    });
  }
}
