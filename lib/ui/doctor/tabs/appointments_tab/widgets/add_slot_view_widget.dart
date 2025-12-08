import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/ui/doctor/tabs/appointments_tab/view_model/slot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSlotsDialog {
  static Future<void> showAddDialog(
    BuildContext parentContext,
    SlotCubit slotCubit, // تمرير Cubit مباشرة
  ) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: parentContext,
      builder: (context) {
        return BlocConsumer<SlotCubit, SlotState>(
          bloc: slotCubit, // نستخدم الـ Cubit المرسل مباشرة
          listenWhen: (previous, current) =>
              previous.addSlot != current.addSlot,
          listener: (context, state) {
            if (state.addSlot is BaseSuccessState<void>) {
              toastMessage(
                message: "تمت الاضافة",
                tybeMessage: TybeMessage.positive,
              );
              Navigator.pop(context);
            }

            if (state.addSlot is BaseErrorState) {
              final errorState = state.addSlot as BaseErrorState;
              toastMessage(
                message: errorState.errorMessage,
                tybeMessage: TybeMessage.negative,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.addSlot is BaseLoadingState;
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('إضافة ميعاد جديد'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: selectedDate == null
                            ? const Text('اختيار التاريخ')
                            : Text(
                                'التاريخ: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                              ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) {
                                  setState(() => selectedDate = date);
                                }
                              },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: selectedTime == null
                            ? const Text('اختيار الوقت')
                            : Text('الوقت: ${selectedTime!.format(context)}'),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() => selectedTime = time);
                                }
                              },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (selectedDate != null &&
                                  selectedTime != null) {
                                final dateTime = DateTime(
                                  selectedDate!.year,
                                  selectedDate!.month,
                                  selectedDate!.day,
                                  selectedTime!.hour,
                                  selectedTime!.minute,
                                );
                                slotCubit.addSlot(
                                  dateTime,
                                ); // نستخدم Cubit المرسل مباشرة
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('إضافة'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
