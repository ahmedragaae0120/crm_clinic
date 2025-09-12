import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/data/model/doctor/available_slot_model.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/view_model/appointments_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDialog extends StatefulWidget {
  final PatientEntity patient;
  final List<UserModel> doctors;
  final bool update;
  final String? appointmentId;
  final String? oldSlotId;
  final String? oldDoctorId;
  final AppointmentsCubit? appointmentsCubit;

  const BookingDialog({
    super.key,
    required this.patient,
    required this.doctors,
    this.update = false,
    this.appointmentId,
    this.oldSlotId,
    this.appointmentsCubit,
    this.oldDoctorId,
  });

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  String? selectedDoctorId;
  String? selectedSlotId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = ReceptionistDashboardCubit.get(context);
    return BlocListener<ReceptionistDashboardCubit, ReceptionistDashboardState>(
      listener: (context, state) {
        if (state.bookAppointment is BaseSuccessState && !widget.update) {
          toastMessage(
            message: AppStrings.appointmentBookedSuccessfully,
            tybeMessage: TybeMessage.positive,
          );
          Navigator.pop(context);
        }
        if (state.bookAppointment is BaseErrorState && !widget.update) {
          final errorState = state.bookAppointment as BaseErrorState;
          toastMessage(
            message: errorState.errorMessage,
            tybeMessage: TybeMessage.negative,
          );
        }
      },
      child: AlertDialog(
        title: Text(
          "${AppStrings.bookAppointmentForPatient} ${widget.patient.fullName}",
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownMenu<String>(
                  hintText: AppStrings.selectDoctorFirst,
                  requestFocusOnTap: false,

                  onSelected: (String? doctorId) {
                    if (doctorId != null) {
                      setState(() {
                        selectedDoctorId = doctorId;
                        selectedSlotId = null;
                      });
                      cubit.getAvailableSlotsForDoctor(doctorId);
                    }
                  },
                  dropdownMenuEntries: widget.doctors.map((doctor) {
                    return DropdownMenuEntry<String>(
                      value: doctor.uid ?? "",
                      label: doctor.fullName ?? "No Name",
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                if (selectedDoctorId != null)
                  BlocBuilder<
                    ReceptionistDashboardCubit,
                    ReceptionistDashboardState
                  >(
                    builder: (context, state) {
                      if (state.getSlots is BaseLoadingState) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                      }
                      if (state.getSlots is BaseErrorState) {
                        return Center(
                          child: Text(
                            (state.getSlots as BaseErrorState).errorMessage,
                          ),
                        );
                      }
                      if (state.getSlots
                          is BaseSuccessState<List<AvailableSlotModel>>) {
                        return _buildAvailableSlotsList(
                          (state.getSlots
                                      as BaseSuccessState<
                                        List<AvailableSlotModel>
                                      >)
                                  .data ??
                              [],
                          context,
                        );
                      }
                      return Center(child: Text(AppStrings.somethingWentWrong));
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: selectedSlotId != null
                ? () {
                    if (widget.update && widget.appointmentsCubit != null) {
                      widget.appointmentsCubit?.updateAppointmentTime(
                        appointmentId: widget.appointmentId ?? "",
                        oldDoctorId: widget.oldDoctorId ?? "",
                        oldSlotId: widget.oldSlotId ?? "",
                        newDoctorId: selectedDoctorId ?? "",
                        newSlotId: selectedSlotId ?? "",
                      );
                    } else {
                      cubit.bookAppointment(
                        patientId: widget.patient.patientId,
                        doctorId: selectedDoctorId ?? "",
                        slotId: selectedSlotId ?? "",
                        patient: PatientModel(
                          fullName: widget.patient.fullName,
                          phone: widget.patient.phone,
                          gender: widget.patient.gender,
                          birthDate: widget.patient.birthDate,
                          joined: widget.patient.joined,
                          patientId: widget.patient.patientId,
                        ),
                      );
                    }
                  }
                : null,
            child: Text(AppStrings.confirmBooking),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSlotsList(
    List<AvailableSlotModel> availableSlots,
    BuildContext context,
  ) {
    // 1. تجميع المواعيد في Map حسب اليوم
    final Map<DateTime, List<AvailableSlotModel>> groupedSlots = {};
    for (var slot in availableSlots) {
      // التأكد من أن وقت البدء ليس null
      final startTime = slot.startTime ?? DateTime.now();
      // استخدام اليوم فقط كمفتاح للتجميع
      final dayKey = DateTime(startTime.year, startTime.month, startTime.day);

      // إذا لم يكن اليوم موجودًا في الـ Map، قم بإنشاء قائمة جديدة له
      (groupedSlots[dayKey] ??= []);
      // إضافة الموعد الحالي إلى قائمة اليوم المناسب
      groupedSlots[dayKey]!.add(slot);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSlots.entries.map((entry) {
        final day = entry.key;
        final daySlots = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                DateFormat(
                  'EEEE, d MMMM yyyy',
                  context.locale.toString(),
                ).format(day),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: daySlots.map((slot) {
                // الوصول إلى البيانات من خلال خصائص الكائن (object properties)
                final slotTime = slot.startTime;
                final isSelected = selectedSlotId == slot.id;

                return ChoiceChip(
                  label: Text(
                    DateFormat(
                      'hh:mm a',
                      context.locale.toString(),
                    ).format(slotTime ?? DateTime.now()),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedSlotId = slot.id;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const Divider(height: 20),
          ],
        );
      }).toList(),
    );
  }
}
