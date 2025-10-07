import 'dart:developer';

import 'package:crm_clinic/core/animations/list_item_animation.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/add_patient_tab.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/booking_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsCardWidget extends StatelessWidget {
  final int index;
  final AppointmentModel appointment;
  const AppointmentsCardWidget({
    super.key,
    required this.index,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = appointment.doctorName;
    final formattedDate = appointment.dateTime != null
        ? DateFormat(
            'yyyy/MM/dd – hh:mm a',
            context.locale.toString(),
          ).format(appointment.dateTime!)
        : "غير محدد";
    return ListItemAnimation(
      index: index,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          leading: const Icon(Icons.calendar_today, color: Colors.blue),
          title: Text(
            "${appointment.patientName ?? AppStrings.unknownPatient} - ${appointment.patientPhone ?? ''}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${AppStrings.doctor}: $doctorName"),
              Text("${AppStrings.theTime}: $formattedDate"),
              Text("${AppStrings.status}: ${appointment.status}"),
            ],
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'edit') {
                final dashboardCubit = ReceptionistDashboardCubit.get(context);
                final appointmentsCubit = AppointmentsCubit.get(context);
                final patientEntity = PatientEntity(
                  patientId: appointment.patientId ?? "",
                  fullName: appointment.patientName ?? "",
                  phone: appointment.patientPhone ?? "",
                  gender: Gender.male.key,
                  birthDate: DateTime.now().toString(),
                  joined: DateTime.now(),
                );
                final doctors = dashboardCubit.state.allDoctors;
                log(
                  "doctors: ${doctors[0].fullName} \n patient: ${patientEntity.fullName} \n oldSlotId: ${appointment.appointmentId}    \n  ",
                );
                showDialog(
                  context: context,
                  builder: (context) => BlocProvider.value(
                    value: dashboardCubit,
                    child: BookingDialog(
                      patient: patientEntity,
                      doctors: doctors,
                      update: true,
                      oldSlotId: appointment.slotId ?? "",
                      oldDoctorId: appointment.doctorId ?? "",
                      appointmentsCubit: appointmentsCubit,
                      appointmentId: appointment.appointmentId ?? "",
                    ),
                  ),
                );
              } else if (value == 'delete') {
                AppointmentsCubit.get(context).cancelAppointment(
                  appointmentId: appointment.appointmentId ?? "",
                  doctorId: appointment.doctorId ?? "",
                  slotId: appointment.slotId ?? "",
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(AppStrings.editTime)),
              PopupMenuItem(value: 'delete', child: Text(AppStrings.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
