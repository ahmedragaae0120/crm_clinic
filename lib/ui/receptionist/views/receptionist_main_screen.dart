import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/core/utils/dialogs.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/add_patient_tab.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/view_model/add_patient_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/appointments_tab.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/receptionist_dashboard_tab.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_bloc/flutter_bloc.dart';

class ReceptionistMainScreen extends StatefulWidget {
  const ReceptionistMainScreen({super.key});

  @override
  State<ReceptionistMainScreen> createState() => _ReceptionistMainScreenState();
}

class _ReceptionistMainScreenState extends State<ReceptionistMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const AppointmentsTab(),
    const ReceptionistDashboard(),
    const AddPatientTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppointmentsCubit>()),
        BlocProvider(
          create: (_) => getIt<ReceptionistDashboardCubit>()..getAllPatients(),
        ),
        BlocProvider(create: (_) => getIt<AddPatientCubit>()),
      ],
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Scaffold(
          key: ValueKey(context.locale.languageCode),
          appBar: AppBar(
            title: Text(AppStrings.receptionistDashboard),
            leading: IconButton(
              onPressed: () {
                Dialogs.logoutDialog(context: context);
              },
              icon: const Icon(Icons.logout_rounded),
            ),
            actions: [
              Text(context.locale.languageCode),
              IconButton(
                icon: Icon(
                  context.locale.languageCode == 'en'
                      ? Icons.language
                      : Icons.translate,
                ),
                onPressed: () {
                  if (context.locale.languageCode == 'en') {
                    context.setLocale(const Locale('ar'));
                  } else {
                    context.setLocale(const Locale('en'));
                  }
                },
              ),
            ],
          ),

          body: _tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month_outlined),
                label: AppStrings.appointments,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard),
                label: AppStrings.dashboard,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_add),
                label: AppStrings.addPatient,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
