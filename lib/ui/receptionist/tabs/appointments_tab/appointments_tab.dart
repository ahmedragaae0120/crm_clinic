import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/widgets/appointments_card_widget.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/widgets/filter_tab_bar_widget.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_state.dart';
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
                          return AppointmentsCardWidget(
                            index: index,
                            appointment: appointment,
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
