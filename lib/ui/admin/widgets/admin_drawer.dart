import 'package:crm_clinic/core/utils/app_routes.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.signOut is BaseSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (_) => false);
          toastMessage(
              message: "Logout Successfully",
              tybeMessage: TybeMessage.positive);
        }
        if (state.signOut is BaseErrorState) {
          final errorState = state.signOut as BaseErrorState;
          toastMessage(
              message: errorState.errorMessage,
              tybeMessage: TybeMessage.negative);
        }
      },
      child: Drawer(
        child: Container(
          color: theme.colorScheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Admin',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              drawerItem(
                icon: Icons.dashboard,
                text: 'Dashboard',
                context: context,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.admin, (_) => false);
                },
              ),
              drawerItem(
                icon: Icons.logout,
                text: 'Logout',
                context: context,
                onTap: () async {
                  AuthCubit.get(context).signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      required BuildContext context}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onPrimary),
      title: Text(text, style: TextStyle(color: theme.colorScheme.onPrimary)),
      onTap: onTap,
    );
  }
}
