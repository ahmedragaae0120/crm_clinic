import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:flutter/material.dart';

class AppointmentTodayWidget extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentTodayWidget({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSecondary,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 40, color: theme.colorScheme.onPrimary),
          const SizedBox(height: 8),
          Text(
            appointment.patientName ?? '',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Time: ${appointment.dateTime?.hour}:${appointment.dateTime?.minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
