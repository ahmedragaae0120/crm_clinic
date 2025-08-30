import 'dart:developer';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/domain/use_cases/get_all_appointments_usecase.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReceptionistCubit extends Cubit<ReceptionistState> {
  @factoryMethod
  ReceptionistCubit(this._getAllAppointmentsUsecase)
    : super(ReceptionistState());
  final GetAllAppointmentsUsecase _getAllAppointmentsUsecase;

  static ReceptionistCubit get(context) => BlocProvider.of(context);

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
