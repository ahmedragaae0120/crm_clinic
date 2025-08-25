import 'package:crm_clinic/core/utils/app_routes.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_state.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Dialogs {
  static Future<void> logoutDialog({required BuildContext context}) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppStrings.logout,
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        content: Text(
          AppStrings.doYouWantToLogout,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.no),
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.signOut is BaseSuccessState) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
                toastMessage(
                  message: AppStrings.logoutSuccessfully,
                  tybeMessage: TybeMessage.positive,
                );
              }
              if (state.signOut is BaseErrorState) {
                final errorState = state.signOut as BaseErrorState;
                toastMessage(
                  message: errorState.errorMessage,
                  tybeMessage: TybeMessage.negative,
                );
              }
            },

            child: TextButton(
              onPressed: () => AuthCubit.get(context).signOut(),

              child: Text(AppStrings.yes),
            ),
          ),
        ],
      ),
    );
  }

  static showBookingDialog(BuildContext context, PatientEntity patient) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String doctorId = "doctor_123"; // مؤقتًا، بعدين هتجيب من قائمة الدكاترة

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("حجز موعد للمريض ${patient.fullName}"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              // DropdownMenu(
              //   dropdownMenuEntries: [
              //     DropdownMenuEntry(value: 'doctor_123', label: 'د. أحمد علي'),
              //     DropdownMenuEntry(value: 'doctor_456', label: 'د. سارة محمد'),
              //     DropdownMenuEntry(value: 'doctor_789', label: 'د. خالد يوسف'),
              //   ],
              // ),
              DropdownMenu(
                hintText: "اختر العيادة",
                enableSearch: false,
                textAlign: TextAlign.center,
                requestFocusOnTap: false,
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: 'clinic_1',
                    label: 'العيادة الرئيسية',
                  ),
                  DropdownMenuEntry(value: 'clinic_2', label: 'عيادة الأطفال'),
                  DropdownMenuEntry(value: 'clinic_3', label: 'عيادة الأسنان'),
                ],
              ),
              // ElevatedButton.icon(
              //   onPressed: () async {
              //     final date = await showDatePicker(
              //       context: context,
              //       firstDate: DateTime.now(),
              //       lastDate: DateTime(2030),
              //       initialDate: DateTime.now(),
              //     );
              //     if (date != null) selectedDate = date;
              //   },
              //   icon: const Icon(Icons.date_range),
              //   label: const Text("اختر التاريخ"),
              // ),
              // ElevatedButton.icon(
              //   onPressed: () async {
              //     final time = await showTimePicker(
              //       context: context,
              //       initialTime: TimeOfDay.now(),
              //     );
              //     if (time != null) selectedTime = time;
              //   },
              //   icon: const Icon(Icons.access_time),
              //   label: const Text("اختر الوقت"),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  final dateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  ReceptionistCubit.get(context).bookAppointment(
                    patientId: patient.patientId,
                    doctorId: doctorId,
                    dateTime: dateTime,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("تأكيد"),
            ),
          ],
        );
      },
    );
  }
}
