import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/domain/use_cases/add_patient_usecase.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/add_patient_tab.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/view_model/add_patient_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddPatientCubit extends Cubit<AddPatientState> {
  AddPatientCubit(this._addPatientUsecase) : super(AddPatientState());
  final AddPatientUsecase _addPatientUsecase;

  static AddPatientCubit get(context) => BlocProvider.of(context);

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
        if (isClosed) return;

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
}
