import 'dart:developer';
import 'package:crm_clinic/core/utils/layout_builder.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/layout/desktop/desktop_patient_list_builder_widget.dart';
import 'package:crm_clinic/ui/receptionist/layout/mobile/mobile_patient_list_builder_widget.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReceptionistDashboardCubit, ReceptionistDashboardState>(
      buildWhen: (previous, current) =>
          previous.getPatients != current.getPatients ||
          previous.allDoctors != current.allDoctors,
      builder: (context, state) {
        final cubit = ReceptionistDashboardCubit.get(context);

        final getPatientsState = state.getPatients;

        if (getPatientsState is BaseSuccessState<List<PatientEntity>>) {
          final filteredPatients = getPatientsState.data;
          final doctors = state.allDoctors;

          if (filteredPatients == null || filteredPatients.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noMatchingPatientsFound,
                style: theme.textTheme.headlineMedium,
              ),
            );
          }
          log("PatientId in table: ${filteredPatients[0].patientId}");

          // 3. بناء الجدول باستخدام البيانات المفلترة فقط
          return LayoutBuilderWidget(
            mobileLayout: (context) => MobilePatientListBuilderWidget(
              patients: filteredPatients,
              doctors: doctors,
              cubit: cubit,
            ),
            tabletLayout: (context) => DesktopPatientListBuilderWidget(
              patients: filteredPatients,
              cubit: cubit,
              doctors: doctors,
            ),
            desktopLayout: (context) => DesktopPatientListBuilderWidget(
              patients: filteredPatients,
              cubit: cubit,
              doctors: doctors,
            ),
          );
        } else if (state.getPatients is BaseLoadingState) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: theme.primaryColor,
            ),
          );
        } else if (state.getPatients is BaseErrorState) {
          return Center(
            child: Text(
              (state.getPatients as BaseErrorState).errorMessage,
              style: theme.textTheme.headlineLarge,
            ),
          );
        } else {
          return Center(child: Text(AppStrings.somethingWentWrong));
        }
      },
    );
  }
}
