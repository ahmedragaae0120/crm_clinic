import 'package:crm_clinic/ui/admin/admin_view.dart';
import 'package:crm_clinic/ui/auth/login/login_view.dart';
import 'package:crm_clinic/ui/auth/singup/signup_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String admin = '/admin';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginView(),
      signup: (context) => const SignupView(),
      admin: (context) => const AdminView(),
      // main: (context) => const MainScreen(),
    };
  }
}
