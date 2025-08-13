import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/ui/receptionist/views/add_patient_view.dart';
import 'package:flutter/material.dart';

class ReceptionistView extends StatelessWidget {
  const ReceptionistView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptionist Dashboard'),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Welcome to the Receptionist Dashboard',
              style: theme.textTheme.headlineLarge,
            ),
          ),
        ],
      ),
    );
  }
}
