import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/ui/receptionist/views/add_patient_view.dart';
import 'package:crm_clinic/ui/receptionist/views/receptionist_view.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.receptionistDashboard)),

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
    );
  }
}
