import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_state.dart';
import 'package:crm_clinic/core/reusable_comp/validator.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/ui/admin/widgets/role_dropdown_widget.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  UserPermission? _userPermission;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      AuthCubit.get(context).register(
        userModel: UserModel(
          fullName: _fullNameController.text,
          email: _emailController.text,
          joined: DateTime.now(),
          permission: _userPermission!.value,
        ),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.signup is BaseSuccessState) {
          toastMessage(
            message: AppStrings.userAddedSuccessfully,
            tybeMessage: TybeMessage.positive,
          );
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        }
        if (state.signup is BaseErrorState) {
          final errorState = state.signup as BaseErrorState;
          FocusScope.of(context).unfocus();
          toastMessage(
            message: errorState.errorMessage,
            tybeMessage: TybeMessage.negative,
          );
        }
      },
      child: AlertDialog(
        title: Text(AppStrings.addNewUser),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  validator: Validator.name,
                  decoration: InputDecoration(
                    labelText: AppStrings.fullName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  validator: Validator.email,
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    border: const OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: Validator.password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    border: const OutlineInputBorder(),
                  ),
                ),
                RoleDropdownWidget(
                  userPermission: _userPermission,
                  onChanged: (t) {
                    setState(() {
                      _userPermission = t;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(onPressed: _submit, child: Text(AppStrings.create)),
        ],
      ),
    );
  }
}
