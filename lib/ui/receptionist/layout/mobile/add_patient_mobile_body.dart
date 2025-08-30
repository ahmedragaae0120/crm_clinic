import 'package:crm_clinic/core/animations/screen_title_animation.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/reusable_comp/validator.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/view_model/add_patient_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/view_model/add_patient_state.dart';
import 'package:crm_clinic/ui/receptionist/tabs/add_patient_tab/add_patient_tab.dart';
import 'package:flutter/material.dart';

class AddPatientMobileBody extends StatelessWidget {
  final void Function()? addPatient;
  final AddPatientState state;
  final GlobalKey<FormState> formKey;
  const AddPatientMobileBody({
    super.key,
    this.addPatient,
    required this.state,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    final cubit = AddPatientCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Config.spaceSmall,
            Center(
              child: ScreenTitleAnimation(
                title: AppStrings.formToAddNewPatient,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: AppStrings.fullName),
              controller: cubit.nameController,
              validator: Validator.name,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: AppStrings.phoneNumber),
              keyboardType: TextInputType.phone,
              validator: Validator.phoneNumber,
              controller: cubit.phoneController,
            ),
            GestureDetector(
              onTap: () => cubit.pickDate(context),
              child: AbsorbPointer(
                // prevent keyboard, make readonly
                child: TextFormField(
                  controller: cubit.dateController,
                  decoration: InputDecoration(
                    hintText: AppStrings.birthDate,
                    suffixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: theme.primaryColor,
                    ),
                  ),
                  validator: Validator.date,
                ),
              ),
            ),
            DropdownButtonFormField(
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
              decoration: InputDecoration(hintText: AppStrings.selectGender),
              onChanged: cubit.changeGender,
            ),
            Config.spaceMedium,
            ElevatedButton(
              onPressed: addPatient,
              child: state.addPatient is BaseLoadingState
                  ? const CircularProgressIndicator.adaptive()
                  : Text(AppStrings.addPatient),
            ),
          ],
        ),
      ),
    );
  }
}
