import 'dart:developer';

import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/view_model/home_cubit.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/widgets/appointment_today_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppointmentTodayBuilder extends StatelessWidget {
  final List<AppointmentModel> appointmentsToday;
  const AppointmentTodayBuilder({super.key, required this.appointmentsToday});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.getAppointmentsToday is BaseErrorState) {
          final errorState = state.getAppointmentsToday as BaseErrorState;
          return SliverToBoxAdapter(
            child: Center(child: Text(errorState.errorMessage)),
          );
        }
        if (state.getAppointmentsToday
            is BaseSuccessState<List<AppointmentModel>>) {
          final appointments =
              (state.getAppointmentsToday
                      as BaseSuccessState<List<AppointmentModel>>)
                  .data ??
              [];
          log(appointments.toString());

          if (appointments.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "No Appointments Today",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              width: 120,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: appointments.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return AppointmentTodayWidget(
                    appointment: appointments[index],
                  );
                },
              ),
            ),
          );
        }
        return SliverToBoxAdapter(
          child: Skeletonizer(
            enabled: true,
            effect: const ShimmerEffect(
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFF5F5F5),
            ),
            child: AppointmentTodayWidget(appointment: AppointmentModel()),
          ),
        );
      },
    );
  }
}
