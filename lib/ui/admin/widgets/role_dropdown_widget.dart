import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/reusable_comp/validator.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:flutter/material.dart';

class RoleDropdownWidget extends StatelessWidget {
  final UserPermission? userPermission;
  final void Function(UserPermission?)? onChanged;
  const RoleDropdownWidget({super.key, this.onChanged, this.userPermission});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(AppStrings.selectRole),
      borderRadius: BorderRadius.circular(10),
      value: userPermission,
      isExpanded: true,
      validator: (value) => Validator.dropdownButton(value),
      items: [
        DropdownMenuItem(
          value: UserPermission.doctor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(UserPermission.doctor.name),
              const Icon(
                Icons.expand_circle_down_rounded,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
        DropdownMenuItem(
          value: UserPermission.nurse,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(UserPermission.nurse.name),
              const Icon(
                Icons.expand_circle_down_rounded,
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
        DropdownMenuItem(
          value: UserPermission.receptionist,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(UserPermission.receptionist.name),
              const Icon(Icons.expand_circle_down_rounded, color: Colors.grey),
            ],
          ),
        ),
        DropdownMenuItem(
          value: UserPermission.admin,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(UserPermission.admin.name),
              const Icon(Icons.expand_circle_down_rounded, color: Colors.red),
            ],
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
