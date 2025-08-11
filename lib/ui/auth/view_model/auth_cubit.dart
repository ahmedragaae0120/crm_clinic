import 'dart:developer';

import 'package:crm_clinic/core/cache/shared_pref.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/core/utils/app_routes.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/use_cases/auth/create_admin_email_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/login_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/register_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/signin_with_facebook_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/signin_with_google_usecase.dart';
import 'package:crm_clinic/domain/use_cases/auth/signout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  @factoryMethod
  AuthCubit(
    this._loginUseCase,
    this._registerUsecase,
    this._signinWithGoogleUsecase,
    this._signinWithFacebookUsecase,
    this._firebaseManager,
    this._signoutUsecase,
    this._cacheHelper,
    this._createAdminEmailUsecase,
  ) : super(AuthState());
  final LoginUseCase _loginUseCase;
  final RegisterUsecase _registerUsecase;
  final SigninWithGoogleUsecase _signinWithGoogleUsecase;
  final SigninWithFacebookUsecase _signinWithFacebookUsecase;
  final SignoutUsecase _signoutUsecase;
  final CreateAdminEmailUsecase _createAdminEmailUsecase;
  final CacheHelper _cacheHelper;
  final FirebaseManager _firebaseManager;

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  login(String email, String password) async {
    emit(state.copyWith(login: BaseLoadingState()));
    final result = await _loginUseCase(email: email, password: password);
    switch (result) {
      case Success():
        _cacheHelper.setRememberMe(true);
        final navigation = await getNavigation(result.data!.user!.uid);
        emit(state.copyWith(login: BaseSuccessState<String>(navigation)));

        break;
      case Error():
        emit(state.copyWith(
            login:
                BaseErrorState(result.exception.toString(), result.exception)));
    }
  }

  register({required UserModel userModel, required String password}) async {
    emit(state.copyWith(signup: BaseLoadingState()));
    final result =
        await _registerUsecase(userModel: userModel, password: password);
    switch (result) {
      case Success():
        emit(state.copyWith(signup: BaseSuccessState(null)));
        break;
      case Error():
        emit(state.copyWith(
            signup:
                BaseErrorState(result.exception.toString(), result.exception)));
    }
  }

  // signInWithGoogle() async {
  //   emit(SigninWithGoogleLoading());
  //   final result = await _signinWithGoogleUsecase();
  //   switch (result) {
  //     case Success():
  //       emit(SigninWithGoogleSuccess(result.data as UserCredential));
  //       break;
  //     case Error():
  //       emit(SigninWithGoogleFailure(result.exception.toString()));
  //   }
  // }

  // signInWithFacebook() async {
  //   emit(SigninWithFacebookLoading());
  //   final result = await _signinWithFacebookUsecase();
  //   switch (result) {
  //     case Success():
  //       emit(SigninWithFacebookSuccess(result.data as UserCredential));
  //       break;
  //     case Error():
  //       emit(SigninWithFacebookFailure(result.exception.toString()));
  //   }
  // }

  Future<String> getNavigation(String uid) async {
    final userPermission = await _firebaseManager.getUserPermission(uid);
    switch (userPermission) {
      case UserPermission.admin:
        log("permission admin");
        return AppRoutes.admin;
      // case UserPermission.doctor:
      //   return AppRoutes.doctor;
      // case UserPermission.nurse:
      //   return AppRoutes.nurse;
      // case UserPermission.receptionist:
      //   return AppRoutes.receptionist;
      default:
        log("permission default");
        return AppRoutes.login;
    }
  }

  Future<String> initRoute() async {
    final isRememberMe = await _cacheHelper.getRememberMe() ?? false;
    final currentUser = _firebaseManager.currentUser;

    if (isRememberMe && currentUser != null) {
      final userPermission =
          await _firebaseManager.getUserPermission(currentUser.uid);
      switch (userPermission) {
        case UserPermission.admin:
          return AppRoutes.admin;
        // case UserPermission.doctor:
        //   return RouteManager.adminDashboard;
        //   break;
        // case UserPermission.nurse:
        //   return RouteManager.adminDashboard;
        //   break;
        // case UserPermission.receptionist:
        //   return RouteManager.adminDashboard;

        default:
          return AppRoutes.login;
      }
    } else {
      return AppRoutes.login;
    }
  }

  signOut() async {
    emit(state.copyWith(signOut: BaseLoadingState()));
    final result = await _signoutUsecase.call();
    switch (result) {
      case Success():
        await _cacheHelper.setRememberMe(false);
        emit(state.copyWith(signOut: BaseSuccessState(null)));
        break;
      case Error():
        emit(state.copyWith(
            signOut:
                BaseErrorState(result.exception.toString(), result.exception)));
    }
  }

  createAdminEmail() async {
    final result = await _createAdminEmailUsecase();
    switch (result) {
      case Success():
        return result;
      case Error():
        return result.exception.toString();
    }
  }
}
