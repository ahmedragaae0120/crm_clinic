import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
import 'package:crm_clinic/ui/receptionist/widgets/patients_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FilteredPatients {
  all('all'),
  today('today'),
  thisWeek('thisWeek'),
  thisMonth('thisMonth');

  final String key;
  const FilteredPatients(this.key);
  String get value => key.tr();
}

class ReceptionistView extends StatelessWidget {
  const ReceptionistView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Config.spaceSmall,
              Center(
                child: Text(
                  AppStrings.welcomeReceptionistDashboard,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      expands: false,
                      onChanged: (value) {
                        ReceptionistCubit.get(context).searchPatients(value);
                      },
                      decoration: InputDecoration(
                        labelText: AppStrings.searchByNameOrPhone,
                        hintText: AppStrings.enterPatientDetails,
                        prefixIcon: const Icon(Icons.search),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<ReceptionistCubit, ReceptionistState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          PopupMenuButton(
                            icon: const Icon(Icons.filter_alt_rounded),
                            initialValue: ReceptionistCubit.get(
                              context,
                            ).filteredPatientType,

                            onSelected: (FilteredPatients value) {
                              ReceptionistCubit.get(
                                context,
                              ).filteredPatient(value);
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: FilteredPatients.all,
                                child: Text(FilteredPatients.all.value),
                              ),
                              PopupMenuItem(
                                value: FilteredPatients.today,
                                child: Text(FilteredPatients.today.value),
                              ),
                              PopupMenuItem(
                                value: FilteredPatients.thisWeek,
                                child: Text(FilteredPatients.thisWeek.value),
                              ),
                              PopupMenuItem(
                                value: FilteredPatients.thisMonth,
                                child: Text(FilteredPatients.thisMonth.value),
                              ),
                            ],
                          ),
                          Text(
                            ReceptionistCubit.get(
                              context,
                            ).filteredPatientType.value,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: PatientsTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
