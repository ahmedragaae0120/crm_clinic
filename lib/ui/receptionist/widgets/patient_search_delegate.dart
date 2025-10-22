// import 'package:crm_clinic/core/utils/string_manager.dart';
// import 'package:crm_clinic/domain/entity/patient_entity.dart';
// import 'package:flutter/material.dart';

// class PatientSearchDelegate extends SearchDelegate<PatientEntity?> {
//   final List<PatientEntity> allPatients;
//   PatientSearchDelegate({required this.allPatients});
//   @override
//   // 1. يزيل النص من حقل البحث
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           showSuggestions(context);
//         },
//       ),
//     ];
//   }

//   // 2. يضيف أيقونة للرجوع وإغلاق واجهة البحث
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null); // أغلق البحث وأرجع قيمة null
//       },
//     );
//   }

//   // 3. يعرض النتائج النهائية بعد الضغط على 'بحث'.tr(); في لوحة المفاتيح

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildFilteredList();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildFilteredList();
//   }

//   Widget _buildFilteredList() {
//     if (query.isEmpty) {
//       return Center(child: Text(AppStrings.enterPatientNameOrPhoneToSearch));
//     }

//     final filteredPatients = allPatients.where((patient) {
//       final queryLower = query.toLowerCase();
//       final nameMatches = patient.fullName.toLowerCase().contains(queryLower);
//       final phoneMatches = patient.phone.contains(queryLower);
//       return nameMatches || phoneMatches;
//     }).toList();

//     if (filteredPatients.isEmpty) {
//       return Center(child: Text('${AppStrings.noPatientsFoundFor} "$query".'));
//     }
//     return ListView.builder(
//       itemCount: filteredPatients.length,
//       itemBuilder: (context, index) {
//         final patient = filteredPatients[index];
//         return ListTile(
//           leading: const Icon(Icons.person),
//           title: Text(patient.fullName),
//           subtitle: Text(patient.phone),
//           onTap: () {
//             // عند اختيار مريض، أغلق واجهة البحث وأرجع بيانات المريض
//             close(context, patient);
//           },
//         );
//       },
//     );
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     final theme = Theme.of(context);
//     return theme.copyWith(
//       appBarTheme: theme.appBarTheme.copyWith(
//         backgroundColor: theme.colorScheme.primary,
//         iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
//         titleTextStyle: TextStyle(
//           color: theme.colorScheme.onPrimary,
//           fontSize: 20,
//         ),
//       ),
//       inputDecorationTheme: const InputDecorationTheme(
//         hintStyle: TextStyle(color: Colors.white70),
//         border: InputBorder.none,
//       ),
//     );
//   }
// }
