import 'package:crm_clinic/core/utils/dialogs.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopPatientListBuilderWidget extends StatelessWidget {
  final List<PatientEntity> patients;
  final ReceptionistDashboardCubit cubit;
  final List<UserModel> doctors;

  const DesktopPatientListBuilderWidget({
    super.key,
    required this.patients,
    required this.cubit,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
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
            DataColumn(label: Text(AppStrings.bookAnAppointment)),
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
                    onPressed: () {
                      Dialogs.confirmDialogs(
                        context: context,
                        message: AppStrings.areYouSureAboutThisProcedure,
                        title:
                            "${AppStrings.deletePatientFromDatabase} (${patient.fullName})",
                        onConfirm: () {
                          ReceptionistDashboardCubit.get(
                            context,
                          ).removeDoc(patient.patientId);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: BookingDialog(
                            patient: patient,
                            doctors: doctors,
                          ),
                        ),
                      );
                    },
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
