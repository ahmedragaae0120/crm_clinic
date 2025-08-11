part of 'admin_cubit.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class GetAllUsersSuccess extends AdminState {
  final List<UserModel> users;
  GetAllUsersSuccess(this.users);
}

class GetAllUsersLoading extends AdminState {}

class GetAllUsersFailed extends AdminState {
  final String message;
  GetAllUsersFailed(this.message);
}

class RemoveUserSuccess extends AdminState {}

class RemoveUserFailed extends AdminState {
  final String message;
  RemoveUserFailed(this.message);
}

class RemoveUserLoading extends AdminState {}
