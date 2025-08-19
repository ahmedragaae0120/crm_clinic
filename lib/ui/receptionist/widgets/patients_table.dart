import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/domain/entity/patient_entity.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
import 'package:crm_clinic/ui/receptionist/widgets/patient_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientsTable extends StatelessWidget {
  const PatientsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReceptionistCubit, ReceptionistState>(
      builder: (context, state) {
        final getPatientsState = state.getPatients;

        if (getPatientsState is BaseSuccessState<List<PatientEntity>>) {
          final filteredPatients = getPatientsState.data;

          if (filteredPatients == null || filteredPatients.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noMatchingPatientsFound,
                style: theme.textTheme.headlineMedium,
              ),
            );
          }
          // 3. بناء الجدول باستخدام البيانات المفلترة فقط
          return Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            // defaultColumnWidth: const IntrinsicColumnWidth(flex: 1),
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(), // عمود 'Full Name'.tr(); سيأخذ العرض المناسب لمحتواه
              1: FixedColumnWidth(
                130.0,
              ), // عمود 'Phone'.tr(); سيأخذ عرضًا ثابتًا
              2: IntrinsicColumnWidth(), // عمود 'Gender'.tr();
              3: FixedColumnWidth(120.0), // عمود 'Birth Date'.tr();
              4: FixedColumnWidth(210.0), // عمود 'Joined'.tr();
              5: FixedColumnWidth(60.0), // عمود أيقونة الحذف
            },
            border: TableBorder.all(
              color: theme.colorScheme.primary,
              width: 2,
              borderRadius: BorderRadius.circular(5),
            ),
            children: [
              _buildHeader(context),
              ...filteredPatients.map(
                (patient) => patientRow(patient, context),
              ),
            ],
          );
        } else if (state.getPatients is BaseLoadingState) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: theme.primaryColor,
            ),
          );
        } else if (state.getPatients is BaseErrorState) {
          return Center(
            child: Text(
              (state.getPatients as BaseErrorState).errorMessage,
              style: theme.textTheme.headlineLarge,
            ),
          );
        } else {
          return Center(child: Text(AppStrings.somethingWentWrong));
        }
      },
    );
  }

  TableRow _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return TableRow(
      decoration: BoxDecoration(color: theme.colorScheme.primary),

      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.fullName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.phone,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.gender,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.birthDate,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.joined,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.remove_circle_outline_outlined,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
