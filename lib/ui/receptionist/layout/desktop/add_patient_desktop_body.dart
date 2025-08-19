import 'package:crm_clinic/core/utils/string_manager.dart';

import 'package:crm_clinic/core/reusable_comp/validator.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_state.dart';
import 'package:crm_clinic/ui/receptionist/views/add_patient_view.dart';
import 'package:flutter/material.dart';

class AddPatientDesktopBody extends StatelessWidget {
  final void Function()? addPatient;
  final ReceptionistState state;
  final GlobalKey<FormState> formKey;

  const AddPatientDesktopBody({
    super.key,
    this.addPatient,
    required this.state,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    final cubit = ReceptionistCubit.get(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.addNewPatient,

                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Config.spaceMedium,

                /// Row for Name & Phone
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: AppStrings.fullName,
                        ),
                        controller: cubit.nameController,
                        validator: Validator.name,
                      ),
                    ),
                    SizedBox(width: Config.screenWidth! * 0.02),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: AppStrings.phoneNumber,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: Validator.phoneNumber,
                        controller: cubit.phoneController,
                      ),
                    ),
                  ],
                ),
                Config.spaceMedium,

                /// Row for Birth Date & Gender
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => cubit.pickDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: cubit.dateController,
                            decoration: InputDecoration(
                              labelText: AppStrings.birthDate,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: theme.primaryColor,
                              ),
                            ),
                            validator: Validator.date,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Config.screenWidth! * 0.02),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: cubit.selectedGender,
                        validator: (value) => Validator.dropdownButton(value),
                        items: Gender.values
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender.name),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: AppStrings.selectGender,
                        ),
                        onChanged: cubit.changeGender,
                      ),
                    ),
                  ],
                ),
                Config.spaceMedium,

                /// Submit button
                ElevatedButton(
                  onPressed: addPatient,
                  child: state.addPatient is BaseLoadingState
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          AppStrings.addPatient,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
