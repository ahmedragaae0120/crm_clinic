import 'package:crm_clinic/core/animations/list_item_animation.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
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
      ReceptionistCubit.get(context).getAllAppointment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceptionistCubit, ReceptionistState>(
      builder: (context, state) {
        if (state.getAppointments is BaseSuccessState<List<AppointmentModel>>) {
          final appointments =
              (state.getAppointments
                      as BaseSuccessState<List<AppointmentModel>>)
                  .data ??
              [];
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];

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
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              );
            },
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
