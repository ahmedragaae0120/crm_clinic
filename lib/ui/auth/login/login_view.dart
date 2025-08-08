import 'package:crm_clinic/core/reusable_comp/validator.dart';
import 'package:crm_clinic/core/utils/app_routes.dart';
import 'package:crm_clinic/core/utils/app_strings.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/ui/auth/view_model/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void login() {
    if (_formKey.currentState?.validate() ?? false) {
      AuthCubit.get(context)
          .login(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.login),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess || state is SigninWithGoogleSuccess) {
            toastMessage(
                message: AppStrings.loginSucessfully,
                tybeMessage: TybeMessage.positive);
            Navigator.pushReplacementNamed(context, AppRoutes.admin);
          } else if (state is LoginFailure) {
            toastMessage(
                message: state.error, tybeMessage: TybeMessage.negative);
          } else if (state is SigninWithGoogleFailure) {
            toastMessage(
                message: state.error, tybeMessage: TybeMessage.negative);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    Config.spaceSmall,
                    Text(AppStrings.email,
                        style: theme.textTheme.headlineLarge),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: AppStrings.enterYourEmail,
                      ),
                      validator: Validator.email,
                      controller: _emailController,
                    ),
                    Text(AppStrings.password,
                        style: theme.textTheme.headlineLarge),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: AppStrings.enterYourPassword,
                      ),
                      validator: Validator.password,
                      controller: _passwordController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.primary,
                            thickness: 1,
                            indent: 70,
                            endIndent: 10,
                          ),
                        ),
                        Text("Or", style: theme.textTheme.bodyLarge),
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.primary,
                            thickness: 1,
                            indent: 10,
                            endIndent: 70,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/Google.svg"),
                      onPressed: () {
                        AuthCubit.get(context).signInWithGoogle();
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/facebook.svg"),
                      onPressed: () {
                        AuthCubit.get(context).signInWithFacebook();
                      },
                    ),
                    Config.spaceMedium,
                    ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      child: state is LoginLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              AppStrings.login,
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.alreadyHaveAnAccount,
                            style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.signup);
                          },
                          child: Text(AppStrings.register,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.primary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
