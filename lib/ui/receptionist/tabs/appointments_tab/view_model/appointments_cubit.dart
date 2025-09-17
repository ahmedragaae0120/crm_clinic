import 'dart:developer';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/domain/use_cases/cancel_appointment_usecase.dart';
import 'package:crm_clinic/domain/use_cases/get_all_appointments_usecase.dart';
import 'package:crm_clinic/domain/use_cases/update_appointment_time_usecase.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_state.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/patient_filter_popup_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppointmentsCubit extends Cubit<AppointmentsState> {
  @factoryMethod
  AppointmentsCubit(
    this._getAllAppointmentsUsecase,
    this._updateAppointmentTimeDatasource,
    this._cancelAppointmentDatasource,
  ) : super(AppointmentsState());
  final GetAllAppointmentsUsecase _getAllAppointmentsUsecase;
  final UpdateAppointmentTimeUsecase _updateAppointmentTimeDatasource;
  final CancelAppointmentUsecase _cancelAppointmentDatasource;
  FilterByDate filteredAppointmentsType = FilterByDate.today;

  filteredAppointments(FilterByDate filterAppointments) {
    filteredAppointmentsType = filterAppointments;
    emit(state.copyWith(getAppointments: BaseLoadingState()));

    final mainList = state.appointmentsList ?? [];
    if (filterAppointments == FilterByDate.all) {
      emit(state.copyWith(getAppointments: BaseSuccessState(mainList)));
      return;
    }
    final now = DateTime.now();
    final filteredList = mainList.where((appointment) {
      final appointmentDate = appointment.dateTime ?? DateTime.now();
      switch (filterAppointments) {
        case FilterByDate.today:
          return appointmentDate.year == now.year &&
              appointmentDate.month == now.month &&
              appointmentDate.day == now.day;
        case FilterByDate.thisWeek:
          return appointmentDate.isAfter(
                now.subtract(Duration(days: now.weekday - 1)),
              ) &&
              appointmentDate.isBefore(
                now.add(Duration(days: 7 - now.weekday)),
              );
        case FilterByDate.thisMonth:
          return appointmentDate.year == now.year &&
              appointmentDate.month == now.month;
        default:
          return true; // For 'all'.tr();, no filtering
      }
    }).toList();

    emit(state.copyWith(getAppointments: BaseSuccessState(filteredList)));
  }

  Future<void> cancelAppointment({
    required String appointmentId,
    required String doctorId,
    required String slotId,
  }) async {
    emit(state.copyWith(cancelAppointments: BaseLoadingState()));
    final result = await _cancelAppointmentDatasource.call(
      appointmentId: appointmentId,
      doctorId: doctorId,
      slotId: slotId,
    );
    switch (result) {
      case Success():
        emit(state.copyWith(cancelAppointments: BaseSuccessState(null)));
        break;
      case Error():
        emit(
          state.copyWith(
            cancelAppointments: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
        break;
    }
  }

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
          state.copyWith(
            getAppointments: BaseSuccessState(appointmentList),
            appointmentsList: appointmentList,
          ),
        );
        // هنا اعمل فلترة مباشرة بالـ filter الحالي

        filteredAppointments(filteredAppointmentsType);
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
