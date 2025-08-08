// import 'package:crm_clinic/core/reusable_comp/validator.dart';
// import 'package:crm_clinic/core/utils/app_routes.dart';
// import 'package:crm_clinic/core/utils/app_strings.dart';
// import 'package:crm_clinic/core/utils/config.dart';
// import 'package:crm_clinic/core/utils/toast_message.dart';
// import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SignupView extends StatefulWidget {
//   const SignupView({super.key});

//   @override
//   State<SignupView> createState() => _SignupViewState();
// }

// class _SignupViewState extends State<SignupView> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   void register() {
//     if (_formKey.currentState?.validate() ?? false) {
//       AuthCubit.get(context)
//           .register(_emailController.text, _passwordController.text);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     Config().init(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(AppStrings.register),
//       ),
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is SignupSuccess) {
//             toastMessage(
//                 message: AppStrings.registerSucessfully,
//                 tybeMessage: TybeMessage.positive);
//             Navigator.pushReplacementNamed(context, AppRoutes.login);
//           } else if (state is SignupFailure) {
//             toastMessage(
//                 message: state.error, tybeMessage: TybeMessage.negative);
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   spacing: 20,
//                   children: [
//                     Config.spaceSmall,
//                     Text(AppStrings.email,
//                         style: theme.textTheme.headlineLarge),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         hintText: AppStrings.enterYourEmail,
//                       ),
//                       validator: Validator.email,
//                       controller: _emailController,
//                     ),
//                     Text(AppStrings.password,
//                         style: theme.textTheme.headlineLarge),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         hintText: AppStrings.enterYourPassword,
//                       ),
//                       validator: Validator.password,
//                       controller: _passwordController,
//                     ),
//                     Text(AppStrings.confirmPassword,
//                         style: theme.textTheme.headlineLarge),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         hintText: AppStrings.confirmYourPassword,
//                       ),
//                       validator: (value) => Validator.confirmPassword(
//                           value, _passwordController.text),
//                       controller: _confirmPasswordController,
//                     ),
//                     Config.spaceMedium,
//                     ElevatedButton(
//                       onPressed: () {
//                         register();
//                       },
//                       child: state is SignupLoading
//                           ? const CircularProgressIndicator.adaptive()
//                           : const Text(
//                               AppStrings.register,
//                             ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(AppStrings.alreadyHaveAnAccount,
//                             style: theme.textTheme.bodyMedium),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushReplacementNamed(
//                                 context, AppRoutes.login);
//                           },
//                           child: Text(AppStrings.login,
//                               style: theme.textTheme.bodyMedium
//                                   ?.copyWith(color: theme.colorScheme.primary)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
