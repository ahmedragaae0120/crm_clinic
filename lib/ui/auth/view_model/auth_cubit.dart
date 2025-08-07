import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/domain/use_cases/auth/login_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/register_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/signin_with_facebook_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/signin_with_google_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  @factoryMethod
  AuthCubit(this._loginUseCase, this._registerUsecase,
      this._signinWithGoogleUsecase, this._signinWithFacebookUsecase)
      : super(AuthInitial());
  final LoginUseCase _loginUseCase;
  final RegisterUsecase _registerUsecase;
  final SigninWithGoogleUsecase _signinWithGoogleUsecase;
  final SigninWithFacebookUsecase _signinWithFacebookUsecase;

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  login(String email, String password) async {
    emit(LoginLoading());
    final result = await _loginUseCase(email: email, password: password);

    switch (result) {
      case Success():
        emit(LoginSuccess());
        break;
      case Error():
        emit(LoginFailure(result.exception.toString()));
    }
  }

  register(String email, String password) async {
    emit(SignupLoading());
    final result = await _registerUsecase(email: email, password: password);
    switch (result) {
      case Success():
        emit(SignupSuccess());
        break;
      case Error():
        emit(SignupFailure(result.exception.toString()));
    }
  }

  signInWithGoogle() async {
    emit(SigninWithGoogleLoading());
    final result = await _signinWithGoogleUsecase();
    switch (result) {
      case Success():
        emit(SigninWithGoogleSuccess(result.data as UserCredential));
        break;
      case Error():
        emit(SigninWithGoogleFailure(result.exception.toString()));
    }
  }

  signInWithFacebook() async {
    emit(SigninWithFacebookLoading());
    final result = await _signinWithFacebookUsecase();
    switch (result) {
      case Success():
        emit(SigninWithFacebookSuccess(result.data as UserCredential));
        break;
      case Error():
        emit(SigninWithFacebookFailure(result.exception.toString()));
    }
  }
}
