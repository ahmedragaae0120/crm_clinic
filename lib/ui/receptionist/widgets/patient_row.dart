import 'package:easy_localization/easy_localization.dart';

import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/views/add_patient_view.dart';
import 'package:flutter/material.dart';

TableRow patientRow(PatientEntity patient, BuildContext context) {
  // final enumGeneder = toEnum(patient.gender ?? "");
  // final patientId = patient.uid ?? "";

  return TableRow(
    children: [
      cell(patient.fullName),
      cell(patient.phone),
      cell(patient.gender),
      cell(patient.birthDate),
      cell(formatDate(patient.joined)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () {
            ReceptionistCubit.get(context).removeDoc(patient.uid);
          },
          icon: const Icon(Icons.delete_forever),
        ),
      ),
    ],
  );
}

String formatDate(DateTime date) {
  return DateFormat('MMMM d, yyyy h:mm: a').format(date);
}

Gender toEnum(String permission) {
  return Gender.values.firstWhere(
    (e) => e.name.toLowerCase() == permission.toLowerCase(),
  );
}

Widget cell(String text) => Center(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  ),
);
