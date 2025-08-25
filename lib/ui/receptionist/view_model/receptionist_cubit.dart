import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/domain/use_cases/add_patient_usecase.dart';
import 'package:crm_clinic/domain/use_cases/get_all_patients_usecase.dart';
import 'package:crm_clinic/domain/use_cases/remove_doc_usecase.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
import 'package:crm_clinic/ui/receptionist/views/add_patient_view.dart';
import 'package:crm_clinic/ui/receptionist/views/receptionist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReceptionistCubit extends Cubit<ReceptionistState> {
  @factoryMethod
  ReceptionistCubit(
    this._addPatientUsecase,
    this._getAllPatientsUsecase,
    this._removeDocUsecase,
  ) : super(ReceptionistState());
  final AddPatientUsecase _addPatientUsecase;
  final GetAllPatientsUsecase _getAllPatientsUsecase;
  final RemoveDocUsecase _removeDocUsecase;

  static ReceptionistCubit get(context) => BlocProvider.of(context);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  Gender? selectedGender;
  void clear() {
    nameController.clear();
    phoneController.clear();
    dateController.clear();
    selectedGender = null;
    emit(state.copyWith());
  }

  void changeGender(Gender? gender) {
    selectedGender = gender;
    emit(state.copyWith()); // تحديث الواجهة
  }

  void pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      dateController.text = date.toIso8601String().split('T').first;
      emit(state.copyWith());
    }
  }

  void addPatient(PatientModel patientModel) async {
    emit(state.copyWith(addPatient: BaseLoadingState()));
    final result = await _addPatientUsecase.call(patientModel);

    switch (result) {
      case Success():
        clear();
        emit(state.copyWith(addPatient: BaseSuccessState(null)));
        break;
      case Error():
        emit(
          state.copyWith(
            addPatient: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
        break;
    }
  }

  void getAllPatients() {
    emit(state.copyWith(getPatients: BaseLoadingState()));
    _getAllPatientsUsecase.call().listen((patients) {
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

  Future<void> bookAppointment({
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'patientId': patientId,
        'doctorId': doctorId,
        'dateTime': dateTime.toIso8601String(),
        'status': 'booked',
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Error booking appointment: $e");
    }
  }
}
