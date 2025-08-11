import 'package:bloc/bloc.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/use_cases/get_all_users_usecase.dart';
import 'package:crm_clinic/domain/use_cases/remove_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'admin_state.dart';

@injectable
class AdminCubit extends Cubit<AdminState> {
  @factoryMethod
  AdminCubit(this._getAllUsersUsecase, this._removeUserUsecase)
      : super(AdminInitial());
  final GetAllUsersUsecase _getAllUsersUsecase;
  final RemoveUserUsecase _removeUserUsecase;

  static AdminCubit get(BuildContext context) => BlocProvider.of(context);

  getAllUsers() {
    emit(GetAllUsersLoading());
    _getAllUsersUsecase.call().listen((users) {
      if (users is Success<List<UserModel>>) {
        emit(GetAllUsersSuccess(users.data ?? []));
      } else if (users is Error<List<UserModel>>) {
        emit(GetAllUsersFailed(users.exception.toString()));
      }
    });
  }

  removeUser(String userId) async {
    emit(RemoveUserLoading());
    final result = await _removeUserUsecase.call(userId);
    switch (result) {
      case Success():
        emit(RemoveUserSuccess());
        break;
      case Error():
        emit(RemoveUserFailed(result.exception.toString()));
        break;
    }
  }
}
