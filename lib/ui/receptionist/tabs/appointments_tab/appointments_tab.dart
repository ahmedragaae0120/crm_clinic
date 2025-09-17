import 'dart:developer';

import 'package:crm_clinic/core/animations/list_item_animation.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/add_patient_tab.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/widgets/filter_tab_bar_widget.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/booking_dialog.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});
  @override
  State<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppointmentsCubit.get(context).getAllAppointment();
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return BlocConsumer<AppointmentsCubit, AppointmentsState>(
      listenWhen: (previous, current) =>
          previous.updateAppointments != current.updateAppointments,
      listener: (context, state) {
        if (state.updateAppointments is BaseSuccessState) {
          toastMessage(
            message: AppStrings.updatedSuccessfully,
            tybeMessage: TybeMessage.positive,
          );
          Navigator.pop(context);
        }
        if (state.updateAppointments is BaseErrorState) {
          final errorState = state.updateAppointments as BaseErrorState;
          toastMessage(
            message: errorState.errorMessage,
            tybeMessage: TybeMessage.negative,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state.getAppointments is BaseSuccessState<List<AppointmentModel>>) {
          final appointments =
              (state.getAppointments
                      as BaseSuccessState<List<AppointmentModel>>)
                  .data ??
              [];

          return Column(
            children: [
              SizedBox(height: Config.hightSize! * 0.02),
              const FilterTabBarWidget(),
              appointments.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(AppStrings.noAppointmentsFound),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];

                          log(
                            "Appointments: ${appointments.length} , appointment id: ${appointment.appointmentId}  ,doctor Id: ${appointment.doctorId}   patient Id: ${appointment.patientId} ",
                          );

                          final doctorName = [appointment.doctorId];
                          final formattedDate = appointment.dateTime != null
                              ? DateFormat(
                                  'yyyy/MM/dd – hh:mm a',
                                  context.locale.toString(),
                                ).format(appointment.dateTime!)
                              : "غير محدد";

                          return ListItemAnimation(
                            index: index,
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "${appointment.patientName ?? AppStrings.unknownPatient} - ${appointment.patientPhone ?? ''}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${AppStrings.doctor}: $doctorName"),
                                    Text(
                                      "${AppStrings.theTime}: $formattedDate",
                                    ),
                                    Text(
                                      "${AppStrings.status}: ${appointment.status}",
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      final dashboardCubit =
                                          ReceptionistDashboardCubit.get(
                                            context,
                                          );
                                      final appointmentsCubit =
                                          AppointmentsCubit.get(context);
                                      final patientEntity = PatientEntity(
                                        patientId: appointment.patientId ?? "",
                                        fullName: appointment.patientName ?? "",
                                        phone: appointment.patientPhone ?? "",
                                        gender: Gender.male.key,
                                        birthDate: DateTime.now().toString(),
                                        joined: DateTime.now(),
                                      );
                                      final doctors =
                                          dashboardCubit.state.allDoctors;
                                      log(
                                        "doctors: ${doctors[0].fullName} \n patient: ${patientEntity.fullName} \n oldSlotId: ${appointment.appointmentId}    \n  ",
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            BlocProvider.value(
                                              value: dashboardCubit,
                                              child: BookingDialog(
                                                patient: patientEntity,
                                                doctors: doctors,
                                                update: true,
                                                oldSlotId:
                                                    appointment.slotId ?? "",
                                                oldDoctorId:
                                                    appointment.doctorId ?? "",
                                                appointmentsCubit:
                                                    appointmentsCubit,
                                                appointmentId:
                                                    appointment.appointmentId ??
                                                    "",
                                              ),
                                            ),
                                      );
                                    } else if (value == 'delete') {
                                      AppointmentsCubit.get(
                                        context,
                                      ).cancelAppointment(
                                        appointmentId:
                                            appointment.appointmentId ?? "",
                                        doctorId: appointment.doctorId ?? "",
                                        slotId: appointment.slotId ?? "",
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(AppStrings.editTime),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(AppStrings.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        }

        if (state.getAppointments is BaseErrorState) {
          return Center(
            child: Text((state.getAppointments as BaseErrorState).errorMessage),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
