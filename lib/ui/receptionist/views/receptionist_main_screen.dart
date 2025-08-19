import 'package:crm_clinic/core/utils/dialogs.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/ui/receptionist/views/add_patient_view.dart';
import 'package:crm_clinic/ui/receptionist/views/receptionist_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ReceptionistMainScreen extends StatefulWidget {
  const ReceptionistMainScreen({super.key});

  @override
  State<ReceptionistMainScreen> createState() => _ReceptionistMainScreenState();
}

class _ReceptionistMainScreenState extends State<ReceptionistMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = const [ReceptionistView(), AddPatientView()];

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),

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
