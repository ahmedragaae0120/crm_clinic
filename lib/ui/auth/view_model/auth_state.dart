import 'package:crm_clinic/core/utils/base_state.dart';

class AuthState {
  BaseState? login;
  BaseState? signup;
  BaseState? signOut;

  AuthState({this.login, this.signup, this.signOut});

  AuthState copyWith({
    BaseState? login,
    BaseState? signup,
    BaseState? signOut,
  }) {
    return AuthState(
      login: login ?? this.login,
      signup: signup ?? this.signup,
      signOut: signOut ?? this.signOut,
    );
  }
}

// final class AuthInitial extends AuthState {}

// final class LoginSuccess extends AuthState {}

// final class LoginFailure extends AuthState {
//   LoginFailure(this.error);
//   final String error;
// }

// final class LoginLoading extends AuthState {}

// final class SignupSuccess extends AuthState {}

// final class SignupFailure extends AuthState {
//   SignupFailure(this.error);
//   final String error;
// }

// final class SignupLoading extends AuthState {}

// final class SigninWithGoogleSuccess extends AuthState {
//   SigninWithGoogleSuccess(this.userCredential);
//   final UserCredential userCredential;
// }

// final class SigninWithGoogleFailure extends AuthState {
//   SigninWithGoogleFailure(this.error);
//   final String error;
// }

// final class SigninWithGoogleLoading extends AuthState {}

// final class SigninWithFacebookSuccess extends AuthState {
//   SigninWithFacebookSuccess(this.userCredential);
//   final UserCredential userCredential;
// }

// final class SigninWithFacebookFailure extends AuthState {
//   SigninWithFacebookFailure(this.error);
//   final String error;
// }

// final class SigninWithFacebookLoading extends AuthState {}
