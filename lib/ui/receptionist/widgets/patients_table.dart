import 'dart:developer';

import 'package:crm_clinic/core/utils/dialogs.dart';
import 'package:crm_clinic/core/utils/layout_builder.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientsTable extends StatelessWidget {
  const PatientsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReceptionistCubit, ReceptionistState>(
      builder: (context, state) {
        final getPatientsState = state.getPatients;

        if (getPatientsState is BaseSuccessState<List<PatientEntity>>) {
          final filteredPatients = getPatientsState.data;

          if (filteredPatients == null || filteredPatients.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noMatchingPatientsFound,
                style: theme.textTheme.headlineMedium,
              ),
            );
          }
          // 3. بناء الجدول باستخدام البيانات المفلترة فقط
          return LayoutBuilderWidget(
            mobileLayout: (context) =>
                _buildListView(context, filteredPatients),
            tabletLayout: (context) =>
                _buildDataTable(context, filteredPatients),
            desktopLayout: (context) =>
                _buildDataTable(context, filteredPatients),
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

  /// ✅ طريقة العرض على الموبايل (ListView + Cards)
  Widget _buildListView(BuildContext context, List<PatientEntity> patients) {
    log("Building ListView for ${patients.length} patients");
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            color: Colors.blue,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ListTile(
                  title: Text(
                    patient.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📞 ${patient.phone}"),
                      Text("⚧ ${patient.gender}"),
                      Text("🎂 ${patient.birthDate}"),
                      Text(
                        "📅 ${AppStrings.joined}: ${DateFormat("dd/MM/yyyy").format(patient.joined)}",
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Dialogs.showBookingDialog(context, patient);
                            // BottomSheet(onClosing: () {}, builder: bu)
                          },
                          child: const Text("حجز موعد"),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => ReceptionistCubit.get(
                    context,
                  ).removeDoc(patient.patientId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, List<PatientEntity> patients) {
    log("Building DataTable for ${patients.length} patients");

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: DataTable(
          columns: [
            DataColumn(label: Text(AppStrings.fullName)),
            DataColumn(label: Text(AppStrings.phone)),
            DataColumn(label: Text(AppStrings.gender)),
            DataColumn(label: Text(AppStrings.birthDate)),
            DataColumn(label: Text(AppStrings.joined)),
            DataColumn(label: Text(AppStrings.actions)),
          ],
          rows: patients.map((patient) {
            return DataRow(
              cells: [
                DataCell(Text(patient.fullName)),
                DataCell(Text(patient.phone)),
                DataCell(Text(patient.gender)),
                DataCell(Text(patient.birthDate)),
                DataCell(Text(patient.joined.toString())),
                DataCell(
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () => ReceptionistCubit.get(
                      context,
                    ).removeDoc(patient.patientId),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
