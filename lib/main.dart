import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/firebase_options.dart';
import 'package:crm_clinic/my_app.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();

  final authCubit = getIt<AuthCubit>();
  await authCubit.createAdminEmail();
  final initialRoute = await authCubit.initRoute();
  runApp(BlocProvider.value(
    value: authCubit,
    child: MyApp(
      initialRoute: initialRoute,
    ),
  ));
}
