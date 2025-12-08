import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/ui/doctor/tabs/appointments_tab/appointments_tab_view.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/home_tab_view.dart';
import 'package:crm_clinic/ui/doctor/tabs/profile_tab/profile_tab_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({super.key});

  @override
  State<DoctorMainScreen> createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const HomeTabView(),
    const AppointmentsTabView(),
    const ProfileTabView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: AppStrings.appointments,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
      body: _tabs[_currentIndex],
    );
  }
}
