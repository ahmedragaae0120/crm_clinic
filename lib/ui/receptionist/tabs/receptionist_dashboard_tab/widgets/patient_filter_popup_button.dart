import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FilterByDate {
  all('all'),
  today('today'),
  thisWeek('thisWeek'),
  thisMonth('thisMonth');

  final String key;
  const FilterByDate(this.key);
  String get value => key.tr();
}

class PatientFilterPopupButton extends StatelessWidget {
  final ReceptionistDashboardCubit cubit;
  const PatientFilterPopupButton({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReceptionistDashboardCubit, ReceptionistDashboardState>(
      builder: (context, state) {
        return Column(
          children: [
            PopupMenuButton(
              icon: const Icon(Icons.filter_alt_rounded),
              initialValue: cubit.filteredPatientType,

              onSelected: (FilterByDate value) {
                cubit.filteredPatient(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: FilterByDate.all,
                  child: Text(FilterByDate.all.value),
                ),
                PopupMenuItem(
                  value: FilterByDate.today,
                  child: Text(FilterByDate.today.value),
                ),
                PopupMenuItem(
                  value: FilterByDate.thisWeek,
                  child: Text(FilterByDate.thisWeek.value),
                ),
                PopupMenuItem(
                  value: FilterByDate.thisMonth,
                  child: Text(FilterByDate.thisMonth.value),
                ),
              ],
            ),
            Text(
              cubit.filteredPatientType.value,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        );
      },
    );
  }
}
