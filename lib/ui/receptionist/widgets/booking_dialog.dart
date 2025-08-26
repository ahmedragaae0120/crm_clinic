import 'dart:developer';

import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  final PatientEntity patient;
  final List<UserModel> doctors;
  const BookingDialog({
    super.key,
    required this.patient,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
    log(doctors.length.toString());
    return AlertDialog(
      title: Text("حجز موعد للمريض ${patient.fullName}"),
      content: Column(
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
              // DropdownMenuEntry(value: 'clinic_1', label: 'العيادة الرئيسية'),
              // DropdownMenuEntry(value: 'clinic_2', label: 'عيادة الأطفال'),
              // DropdownMenuEntry(value: 'clinic_3', label: 'عيادة الأسنان'),
              ...doctors.map(
                (doctor) => DropdownMenuEntry(
                  value: doctor.uid,
                  label: doctor.fullName ?? "",
                ),
              ),
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
            // if (selectedDate != null && selectedTime != null) {
            //   final dateTime = DateTime(
            //     selectedDate!.year,
            //     selectedDate!.month,
            //     selectedDate!.day,
            //     selectedTime!.hour,
            //     selectedTime!.minute,
            //   );
            //   ReceptionistCubit.get(context).bookAppointment(
            //     patientId: patient.patientId,
            //     doctorId: doctorId,
            //     dateTime: dateTime,
            //   );
            //   Navigator.pop(context);
            // }
          },
          child: const Text("تأكيد"),
        ),
      ],
    );
  }
}
