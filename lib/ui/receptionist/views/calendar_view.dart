import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final String doctorId;
  const CalendarView({super.key, required this.doctorId});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _service = FirebaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor's Calendar")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text("اختر يومًا لرؤية المواعيد"))
                : StreamBuilder<List<AppointmentModel>>(
                    stream: _service.getAppointmentsByDate(
                      _selectedDay!,
                      widget.doctorId,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final appointments = snapshot.data!;
                      if (appointments.isEmpty) {
                        return const Center(child: Text("لا توجد مواعيد"));
                      }
                      return ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appt = appointments[index];
                          return ListTile(
                            title: Text("موعد مع ${appt.patientId}"),
                            subtitle: Text(appt.dateTime.toString()),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text("تعديل"),
                                ),
                                const PopupMenuItem(
                                  value: 'cancel',
                                  child: Text("إلغاء"),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  // TODO: افتح Dialog لتعديل الوقت
                                } else if (value == 'cancel') {
                                  _service.cancelAppointment(appt.id ?? "");
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
