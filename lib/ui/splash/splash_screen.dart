import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final String navigationRoute;
  const SplashScreen({super.key, required this.navigationRoute});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final initialRoute = await getNavigationRoute();
    if (!mounted) return; // ✅ تأكد أن الـ Widget لسه موجود

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return; // ✅ كمان هنا في حال الشاشة اتقفلت أثناء التأخير
      Navigator.pushReplacementNamed(context, initialRoute);
    });
  }

  Future<String> getNavigationRoute() async {
    final authCubit = getIt<AuthCubit>();
    final initialRoute = await authCubit.initRoute();
    return initialRoute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/icons/animated_splash.json",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
