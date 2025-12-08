import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/view_model/home_cubit.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/widgets/appointment_today_builder.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/widgets/receptionist_users_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()
        ..getAppointmentsToday()
        ..getAllReceptionist(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Today's Appointments ",
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ),
          const AppointmentTodayBuilder(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Receptionist",
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ),
          const ReceptionistUsersBuilder(),
        ],
      ),
    );
  }
}
