import 'dart:async';
import 'dart:developer';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/domain/use_cases/book_appointment_usecase.dart';
import 'package:crm_clinic/domain/use_cases/doctor/get_available_slots_for_doctor_usecase.dart';
import 'package:crm_clinic/domain/use_cases/get_all_doctors_usecase.dart';
import 'package:crm_clinic/domain/use_cases/get_all_patients_usecase.dart';
import 'package:crm_clinic/domain/use_cases/remove_doc_usecase.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/patient_filter_popup_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'receptionist_dashboard_state.dart';

@injectable
class ReceptionistDashboardCubit extends Cubit<ReceptionistDashboardState> {
  ReceptionistDashboardCubit(
    this._getAllPatientsUsecase,
    this._removeDocUsecase,
    this._getAllDoctorsUsecase,
    this._getAvailableSlotsForDoctorUsecase,
    this._bookAppointmentUsecase,
  ) : super(ReceptionistDashboardState());
  final GetAllPatientsUsecase _getAllPatientsUsecase;
  final RemoveDocUsecase _removeDocUsecase;
  final GetAllDoctorsUsecase _getAllDoctorsUsecase;
  final GetAvailableSlotsForDoctorUsecase _getAvailableSlotsForDoctorUsecase;
  final BookAppointmentUsecase _bookAppointmentUsecase;

  static ReceptionistDashboardCubit get(context) => BlocProvider.of(context);
  @override
  Future<void> close() {
    _patientsSubscription?.cancel();
    return super.close();
  }

  StreamSubscription? _patientsSubscription;

  void getAllPatients() {
    if (state.allPatients.isNotEmpty) {
      emit(state.copyWith(getPatients: BaseSuccessState(state.allPatients)));
      return;
    }
    emit(state.copyWith(getPatients: BaseLoadingState()));

    if (state.allDoctors.isEmpty) {
      getAllDoctors();
    }
    _patientsSubscription?.cancel(); // إلغاء أي استماع قديم
    _getAllPatientsUsecase.call().listen((patients) {
      if (isClosed) return;

      if (patients is Success<List<PatientEntity>>) {
        final patientList = patients.data ?? [];
        log('Patients fetched successfully: ${patients.data?.length}');

        emit(
          state.copyWith(
            getPatients: BaseSuccessState(patientList),
            allPatients: patientList,
          ),
        );
      } else if (patients is Error<List<PatientEntity>>) {
        emit(
          state.copyWith(
            getPatients: BaseErrorState(
              patients.exception.toString(),
              patients.exception,
            ),
          ),
        );
      }
    });
  }

  void getAllDoctors() async {
    emit(state.copyWith(getDoctors: BaseLoadingState()));
    final result = await _getAllDoctorsUsecase.call();
    switch (result) {
      case Success():
        if (isClosed) return;

        log("Doctors fetched successfully: ${result.data?.length}");
        emit(
          state.copyWith(
            getDoctors: BaseSuccessState(result.data),
            allDoctors: result.data ?? [],
          ),
        );
        break;
      case Error():
        log("Error fetching doctors: ${result.exception}");
        emit(
          state.copyWith(
            getDoctors: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
        break;
    }
  }

  removeDoc(String id) async {
    final mainList = state.allPatients;
    final result = await _removeDocUsecase.call(id: id);
    switch (result) {
      case Success():
        mainList.removeWhere((patient) => patient.patientId == id);
        emit(state.copyWith(getPatients: BaseSuccessState(mainList)));
        // getAllPatients(); // إعادة تحميل المرضى بعد الحذف
        break;
      case Error():
        emit(
          state.copyWith(
            getPatients: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
        break;
    }
  }

  FilteredPatients filteredPatientType = FilteredPatients.all;
  filteredPatient(FilteredPatients filteredPatients) {
    filteredPatientType = filteredPatients;
    emit(state.copyWith());
    final mainList = state.allPatients;
    if (filteredPatients == FilteredPatients.all) {
      emit(state.copyWith(getPatients: BaseSuccessState(mainList)));
      return;
    }
    final now = DateTime.now();
    final filteredList = mainList.where((patient) {
      final joinedDate = patient.joined;
      switch (filteredPatients) {
        case FilteredPatients.today:
          return joinedDate.year == now.year &&
              joinedDate.month == now.month &&
              joinedDate.day == now.day;
        case FilteredPatients.thisWeek:
          return joinedDate.isAfter(
                now.subtract(Duration(days: now.weekday - 1)),
              ) &&
              joinedDate.isBefore(now.add(Duration(days: 7 - now.weekday)));
        case FilteredPatients.thisMonth:
          return joinedDate.year == now.year && joinedDate.month == now.month;
        default:
          return true; // For 'all'.tr();, no filtering
      }
    }).toList();

    emit(state.copyWith(getPatients: BaseSuccessState(filteredList)));
  }

  searchPatients(String query) {
    final mainList = state.allPatients;

    if (query.isEmpty) {
      emit(state.copyWith(getPatients: BaseSuccessState(mainList)));
      return;
    }
    final filteredList = mainList.where((patient) {
      final queryLower = query.toLowerCase();
      final nameMatches = patient.fullName.toLowerCase().contains(queryLower);
      final phoneMatches = patient.phone.contains(queryLower);
      return nameMatches || phoneMatches;
    }).toList();

    emit(state.copyWith(getPatients: BaseSuccessState(filteredList)));
  }

  getAvailableSlotsForDoctor(String doctorId) async {
    emit(state.copyWith(getSlots: BaseLoadingState()));
    final result = await _getAvailableSlotsForDoctorUsecase.call(
      doctorId: doctorId,
    );
    switch (result) {
      case Success():
        emit(state.copyWith(getSlots: BaseSuccessState(result.data)));
        break;
      case Error():
        emit(
          state.copyWith(
            getSlots: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
        break;
    }
  }

  Future<void> bookAppointment({
    required String patientId,
    required String doctorId,
    required String slotId,
    required PatientModel patient,
  }) async {
    emit(state.copyWith(bookAppointment: BaseLoadingState()));
    final result = await _bookAppointmentUsecase.call(
      patientId: patientId,
      doctorId: doctorId,
      slotId: slotId,
      patient: patient,
    );
    switch (result) {
      case Success():
        emit(state.copyWith(bookAppointment: BaseSuccessState(null)));
        break;
      case Error():
        emit(
          state.copyWith(
            bookAppointment: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
        break;
    }
  }
}
