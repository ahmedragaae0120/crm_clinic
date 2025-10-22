import 'package:crm_clinic/core/utils/app_routes.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Dialogs {
  static Future<void> logoutDialog({required BuildContext context}) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppStrings.logout,
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        content: Text(
          AppStrings.doYouWantToLogout,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.no),
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.signOut is BaseSuccessState) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
                toastMessage(
                  message: AppStrings.logoutSuccessfully,
                  tybeMessage: TybeMessage.positive,
                );
              }
              if (state.signOut is BaseErrorState) {
                final errorState = state.signOut as BaseErrorState;
                toastMessage(
                  message: errorState.errorMessage,
                  tybeMessage: TybeMessage.negative,
                );
              }
            },

            child: TextButton(
              onPressed: () => AuthCubit.get(context).signOut(),

              child: Text(AppStrings.yes),
            ),
          ),
        ],
      ),
    );
  }

  static confirmDialogs({
    required BuildContext context,
    required String message,
    required String title,
    required VoidCallback onConfirm,
  }) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.no),
          ),
          ElevatedButton(
            onPressed: () => onConfirm(),
            child: Text(AppStrings.yes),
          ),
        ],
      ),
    );
  }
}
