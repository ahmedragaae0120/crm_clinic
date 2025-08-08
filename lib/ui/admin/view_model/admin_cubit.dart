import 'package:bloc/bloc.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/domain/use_cases/get_all_users_usecase.dart';
import 'package:injectable/injectable.dart';

part 'admin_state.dart';

@injectable
class AdminCubit extends Cubit<AdminState> {
  @factoryMethod
  AdminCubit(this._getAllUsersUsecase) : super(AdminInitial());
  final GetAllUsersUsecase _getAllUsersUsecase;

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
}
