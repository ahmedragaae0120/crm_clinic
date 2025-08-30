import 'package:crm_clinic/core/animations/list_item_animation.dart';
import 'package:crm_clinic/core/utils/dialogs.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/booking_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobilePatientListBuilderWidget extends StatelessWidget {
  final List<PatientEntity> patients;
  final List<UserModel> doctors;
  final ReceptionistDashboardCubit cubit;
  const MobilePatientListBuilderWidget({
    super.key,
    required this.patients,
    required this.doctors,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return ListItemAnimation(
            index: index,
            child: Card(
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
                              // Dialogs.showBookingDialog(context, patient);
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
                              // BottomSheet(onClosing: () {}, builder: bu)
                            },
                            child: Text(AppStrings.bookAnAppointment),
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
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
