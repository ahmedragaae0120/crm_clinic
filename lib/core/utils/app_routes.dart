import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/ui/admin/admin_view.dart';
import 'package:crm_clinic/ui/admin/view_model/admin_cubit.dart';
import 'package:crm_clinic/ui/auth/login/login_view.dart';
import 'package:crm_clinic/ui/receptionist/view_model/receptionist_cubit.dart';
import 'package:crm_clinic/ui/receptionist/views/receptionist_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String admin = '/admin';
  static const String receptionist = '/receptionist';
  static const String receptionistMainScreen = '/receptionistMainScreen';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginView(),
      // signup: (context) => const SignupView(),
      admin: (context) => BlocProvider<AdminCubit>(
        create: (context) => getIt<AdminCubit>()..getAllUsers(),
        child: const AdminView(),
      ),
      receptionistMainScreen: (context) => BlocProvider<ReceptionistCubit>(
        create: (context) => getIt<ReceptionistCubit>()..getAllPatients(),
        child: const ReceptionistMainScreen(),
      ),
    };
  }
}
