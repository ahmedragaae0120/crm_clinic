import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dart:developer';

import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/core/utils/layout_builder.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/ui/receptionist/layout/desktop/add_patient_desktop_body.dart';
import 'package:crm_clinic/ui/receptionist/layout/mobile/add_patient_mobile_body.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Gender {
  male("male"),
  female("female");

  final String key;
  const Gender(this.key);

  String get name => key.tr();
}

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  final _formKey = GlobalKey<FormState>();
  addPatient() {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = ReceptionistCubit.get(context);
      ReceptionistCubit.get(context).addPatient(
        PatientModel(
          fullName: cubit.nameController.text,
          phone: cubit.phoneController.text,
          gender: cubit.selectedGender!.key,
          birthDate: cubit.dateController.text,
          joined: DateTime.now(),
        ),
      );
      log("Patient added successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return BlocConsumer<ReceptionistCubit, ReceptionistState>(
      listener: (context, state) {
        if (state.addPatient is BaseSuccessState) {
          toastMessage(
            message: AppStrings.patientAddedSuccessfully,
            tybeMessage: TybeMessage.positive,
          );
        } else if (state.addPatient is BaseErrorState) {
          final errorState = state.addPatient as BaseErrorState;
          toastMessage(
            message: errorState.errorMessage,
            tybeMessage: TybeMessage.negative,
          );
        }
      },
      builder: (context, state) {
        return LayoutBuilderWidget(
          mobileLayout: (context) => AddPatientMobileBody(
            formKey: _formKey,
            state: state,
            addPatient: addPatient,
          ),
          tabletLayout: (context) => AddPatientDesktopBody(
            formKey: _formKey,
            state: state,
            addPatient: addPatient,
          ),
          desktopLayout: (context) => AddPatientDesktopBody(
            formKey: _formKey,
            state: state,
            addPatient: addPatient,
          ),
        );
      },
    );
  }
}
