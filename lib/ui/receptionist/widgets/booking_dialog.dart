import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDialog extends StatefulWidget {
  final PatientEntity patient;
  final List<UserModel> doctors;

  const BookingDialog({
    super.key,
    required this.patient,
    required this.doctors,
  });

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  // -- متغيرات الحالة المحلية لإدارة الواجهة --
  String? selectedDoctorId;
  String? selectedSlotId;
  bool isLoadingSlots = false;
  // بيانات وهمية (Fake Data) للمواعيد
  List<Map<String, dynamic>> availableSlots = [];

  // -- دالة لمحاكاة جلب المواعيد --
  Future<void> _fetchFakeSlots(String doctorId) async {
    // 1. عرض مؤشر التحميل
    setState(() {
      isLoadingSlots = true;
      availableSlots = []; // مسح المواعيد القديمة
      selectedSlotId = null; // إلغاء اختيار الموعد السابق
    });

    // 2. محاكاة انتظار استجابة الشبكة
    await Future.delayed(const Duration(seconds: 1));

    // 3. إنشاء بيانات وهمية جديدة
    final now = DateTime.now();
    final fakeData = [
      // اليوم
      {
        'id': 'slot1',
        'startTime': Timestamp.fromDate(
          DateTime(now.year, now.month, now.day, 9, 0),
        ),
      },
      {
        'id': 'slot2',
        'startTime': Timestamp.fromDate(
          DateTime(now.year, now.month, now.day, 9, 30),
        ),
      },
      {
        'id': 'slot3',
        'startTime': Timestamp.fromDate(
          DateTime(now.year, now.month, now.day, 10, 30),
        ),
      },
      // الغد
      {
        'id': 'slot4',
        'startTime': Timestamp.fromDate(
          DateTime(now.year, now.month, now.day + 1, 11, 0),
        ),
      },
      {
        'id': 'slot5',
        'startTime': Timestamp.fromDate(
          DateTime(now.year, now.month, now.day + 1, 11, 30),
        ),
      },
    ];

    // 4. تحديث الواجهة بالبيانات الجديدة وإخفاء مؤشر التحميل
    setState(() {
      availableSlots = fakeData;
      isLoadingSlots = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("حجز موعد للمريض: ${widget.patient.fullName}"),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownMenu<String>(
                hintText: "اختر الطبيب أولاً",
                onSelected: (String? doctorId) {
                  if (doctorId != null) {
                    setState(() {
                      selectedDoctorId = doctorId;
                    });
                    _fetchFakeSlots(doctorId); // استدعاء دالة البيانات الوهمية
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
              if (selectedDoctorId != null) _buildSlotsSection(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          onPressed: selectedSlotId != null
              ? () {
                  // هنا يمكنك وضع منطق الحجز لاحقاً
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حجز الموعد بنجاح! (محاكاة)'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              : null,
          child: const Text("تأكيد الحجز"),
        ),
      ],
    );
  }

  Widget _buildSlotsSection() {
    if (isLoadingSlots) {
      return const Center(child: CircularProgressIndicator());
    }

    if (availableSlots.isEmpty) {
      return const Center(
        child: Text("لا توجد مواعيد متاحة حالياً لهذا الطبيب."),
      );
    }

    return _buildAvailableSlotsList(availableSlots);
  }

  Widget _buildAvailableSlotsList(List<Map<String, dynamic>> slots) {
    final Map<DateTime, List<Map<String, dynamic>>> groupedSlots = {};
    for (var slot in slots) {
      final startTime = (slot['startTime'] as Timestamp).toDate();
      final dayKey = DateTime(startTime.year, startTime.month, startTime.day);

      if (groupedSlots[dayKey] == null) {
        groupedSlots[dayKey] = [];
      }
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
                DateFormat('EEEE, d MMMM yyyy', 'ar').format(day),
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
                final slotTime = (slot['startTime'] as Timestamp).toDate();
                final isSelected = selectedSlotId == slot['id'];

                return ChoiceChip(
                  label: Text(DateFormat('hh:mm a', 'ar').format(slotTime)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedSlotId = slot['id'];
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



    
    
    // AlertDialog(
    //   title: Text("حجز موعد للمريض ${patient.fullName}"),
    //   content: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     spacing: 10,
    //     children: [
    //       // DropdownMenu(
    //       //   dropdownMenuEntries: [
    //       //     DropdownMenuEntry(value: 'doctor_123', label: 'د. أحمد علي'),
    //       //     DropdownMenuEntry(value: 'doctor_456', label: 'د. سارة محمد'),
    //       //     DropdownMenuEntry(value: 'doctor_789', label: 'د. خالد يوسف'),
    //       //   ],
    //       // ),
    //       DropdownMenu(
    //         hintText: "اختر العيادة",
    //         enableSearch: false,
    //         textAlign: TextAlign.center,
    //         requestFocusOnTap: false,
    //         dropdownMenuEntries: [
    //           // DropdownMenuEntry(value: 'clinic_1', label: 'العيادة الرئيسية'),
    //           // DropdownMenuEntry(value: 'clinic_2', label: 'عيادة الأطفال'),
    //           // DropdownMenuEntry(value: 'clinic_3', label: 'عيادة الأسنان'),
    //           ...doctors.map(
    //             (doctor) => DropdownMenuEntry(
    //               value: doctor.uid,
    //               label: doctor.fullName ?? "",
    //             ),
    //           ),
    //         ],
    //       ),
    //       // ElevatedButton.icon(
    //       //   onPressed: () async {
    //       //     final date = await showDatePicker(
    //       //       context: context,
    //       //       firstDate: DateTime.now(),
    //       //       lastDate: DateTime(2030),
    //       //       initialDate: DateTime.now(),
    //       //     );
    //       //     if (date != null) selectedDate = date;
    //       //   },
    //       //   icon: const Icon(Icons.date_range),
    //       //   label: const Text("اختر التاريخ"),
    //       // ),
    //       // ElevatedButton.icon(
    //       //   onPressed: () async {
    //       //     final time = await showTimePicker(
    //       //       context: context,
    //       //       initialTime: TimeOfDay.now(),
    //       //     );
    //       //     if (time != null) selectedTime = time;
    //       //   },
    //       //   icon: const Icon(Icons.access_time),
    //       //   label: const Text("اختر الوقت"),
    //       // ),
    //     ],
    //   ),
    //   actions: [
    //     TextButton(
    //       onPressed: () => Navigator.pop(context),
    //       child: const Text("إلغاء"),
    //     ),
    //     ElevatedButton(
    //       onPressed: () {
    //         // if (selectedDate != null && selectedTime != null) {
    //         //   final dateTime = DateTime(
    //         //     selectedDate!.year,
    //         //     selectedDate!.month,
    //         //     selectedDate!.day,
    //         //     selectedTime!.hour,
    //         //     selectedTime!.minute,
    //         //   );
    //         //   ReceptionistCubit.get(context).bookAppointment(
    //         //     patientId: patient.patientId,
    //         //     doctorId: doctorId,
    //         //     dateTime: dateTime,
    //         //   );
    //         //   Navigator.pop(context);
    //         // }
    //       },
    //       child: const Text("تأكيد"),
    //     ),
    //   ],
    // );
