// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/data_source_contract/add_patient_datasource.dart' as _i901;
import '../../data/data_source_contract/auth/create_admin_email_datasource.dart'
    as _i114;
import '../../data/data_source_contract/auth/login_datasource.dart' as _i1048;
import '../../data/data_source_contract/auth/register_datasource.dart' as _i504;
import '../../data/data_source_contract/auth/signin_with_facebook_datasource.dart'
    as _i489;
import '../../data/data_source_contract/auth/signin_with_google_datasource.dart'
    as _i574;
import '../../data/data_source_contract/auth/signout_datasource.dart' as _i365;
import '../../data/data_source_contract/get_all_users_datasource.dart' as _i332;
import '../../data/data_source_contract/remove_user_datasource.dart' as _i1064;
import '../../data/data_source_impl/add_patient_datasource_impl.dart' as _i708;
import '../../data/data_source_impl/auth/create_admin_email_datasource_impl.dart'
    as _i499;
import '../../data/data_source_impl/auth/login_datasource_impl.dart' as _i1013;
import '../../data/data_source_impl/auth/register_datasource_impl.dart'
    as _i112;
import '../../data/data_source_impl/auth/signin_with_facebook_datasource_impl.dart'
    as _i216;
import '../../data/data_source_impl/auth/signin_with_google_datasource_impl.dart'
    as _i424;
import '../../data/data_source_impl/auth/signout_datasource_impl.dart' as _i107;
import '../../data/data_source_impl/get_all_users_datasource_impl.dart'
    as _i891;
import '../../data/data_source_impl/remove_user_datasource_impl.dart' as _i610;
import '../../data/repo_impl/auth/login_repo_impl.dart' as _i314;
import '../../data/repo_impl/auth/register_repo_impl.dart' as _i853;
import '../../data/repo_impl/auth/signin_with_facebook_repo_impl.dart' as _i28;
import '../../data/repo_impl/auth/signin_with_google_repo_impl.dart' as _i27;
import '../../data/repo_impl/get_all_users_repo_impl.dart' as _i1039;
import '../../domain/repo_contract/auth/login_repo.dart' as _i284;
import '../../domain/repo_contract/auth/register_repo.dart' as _i911;
import '../../domain/repo_contract/auth/signin_with_facebook_repo.dart'
    as _i301;
import '../../domain/repo_contract/auth/signin_with_google_repo.dart' as _i81;
import '../../domain/repo_contract/get_all_users_repo.dart' as _i778;
import '../../domain/use_cases/add_patient_usecase.dart' as _i875;
import '../../domain/use_cases/auth/create_admin_email_usecase.dart' as _i332;
import '../../domain/use_cases/auth/login_usecase.dart' as _i912;
import '../../domain/use_cases/auth/register_usecase.dart' as _i954;
import '../../domain/use_cases/auth/signin_with_facebook_usecase.dart' as _i441;
import '../../domain/use_cases/auth/signin_with_google_usecase.dart' as _i299;
import '../../domain/use_cases/auth/signout_usecase.dart' as _i492;
import '../../domain/use_cases/get_all_users_usecase.dart' as _i967;
import '../../domain/use_cases/remove_user_usecase.dart' as _i374;
import '../../ui/admin/view_model/admin_cubit.dart' as _i705;
import '../../ui/auth/view_model/auth_cubit.dart' as _i538;
import '../../ui/receptionist/view_model/receptionist_cubit.dart' as _i858;
import '../cache/shared_pref.dart' as _i299;
import '../services/firebase_manager.dart' as _i1025;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i299.CacheHelper>(() => _i299.CacheHelper());
    gh.singleton<_i1025.FirebaseManager>(() => _i1025.FirebaseManager());
    gh.factory<_i365.SignoutDatasource>(
        () => _i107.SignoutDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i114.CreateAdminEmailDatasource>(() =>
        _i499.CreateAdminEmailDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i504.RegisterDatasource>(
        () => _i112.RegisterDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i332.CreateAdminEmailUsecase>(() =>
        _i332.CreateAdminEmailUsecase(gh<_i114.CreateAdminEmailDatasource>()));
    gh.factory<_i574.SigninWithGoogleDatasource>(() =>
        _i424.SigninWithGoogleDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i332.GetAllUsersDatasource>(
        () => _i891.GetAllUsersDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i911.RegisterRepo>(
        () => _i853.RegisterRepoImpl(gh<_i504.RegisterDatasource>()));
    gh.factory<_i489.SigninWithFacebookDatasource>(() =>
        _i216.SigninWithFacebookDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i778.GetAllUsersRepo>(
        () => _i1039.GetAllUsersRepoImpl(gh<_i332.GetAllUsersDatasource>()));
    gh.factory<_i901.AddPatientDatasource>(
        () => _i708.AddPatientDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i1048.LoginDatasource>(
        () => _i1013.LoginDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i875.AddPatientUsecase>(
        () => _i875.AddPatientUsecase(gh<_i901.AddPatientDatasource>()));
    gh.factory<_i81.SigninWithGoogleRepo>(() =>
        _i27.SigninWithGoogleRepoImpl(gh<_i574.SigninWithGoogleDatasource>()));
    gh.factory<_i1064.RemoveUserDatasource>(
        () => _i610.RemoveUserDatasourceImpl(gh<_i519.Client>()));
    gh.factory<_i299.SigninWithGoogleUsecase>(
        () => _i299.SigninWithGoogleUsecase(gh<_i81.SigninWithGoogleRepo>()));
    gh.factory<_i284.LoginRepo>(
        () => _i314.LoginRepoImpl(gh<_i1048.LoginDatasource>()));
    gh.factory<_i967.GetAllUsersUsecase>(
        () => _i967.GetAllUsersUsecase(gh<_i778.GetAllUsersRepo>()));
    gh.factory<_i912.LoginUseCase>(
        () => _i912.LoginUseCase(gh<_i284.LoginRepo>()));
    gh.factory<_i492.SignoutUsecase>(
        () => _i492.SignoutUsecase(gh<_i365.SignoutDatasource>()));
    gh.factory<_i954.RegisterUsecase>(
        () => _i954.RegisterUsecase(gh<_i911.RegisterRepo>()));
    gh.factory<_i301.SigninWithFacebookRepo>(() =>
        _i28.SigninWithFacebookRepoImpl(
            gh<_i489.SigninWithFacebookDatasource>()));
    gh.factory<_i374.RemoveUserUsecase>(
        () => _i374.RemoveUserUsecase(gh<_i1064.RemoveUserDatasource>()));
    gh.factory<_i858.ReceptionistCubit>(
        () => _i858.ReceptionistCubit(gh<_i875.AddPatientUsecase>()));
    gh.factory<_i538.AuthCubit>(() => _i538.AuthCubit(
          gh<_i912.LoginUseCase>(),
          gh<_i954.RegisterUsecase>(),
          gh<_i1025.FirebaseManager>(),
          gh<_i492.SignoutUsecase>(),
          gh<_i299.CacheHelper>(),
          gh<_i332.CreateAdminEmailUsecase>(),
        ));
    gh.factory<_i441.SigninWithFacebookUsecase>(() =>
        _i441.SigninWithFacebookUsecase(gh<_i301.SigninWithFacebookRepo>()));
    gh.factory<_i705.AdminCubit>(() => _i705.AdminCubit(
          gh<_i967.GetAllUsersUsecase>(),
          gh<_i374.RemoveUserUsecase>(),
        ));
    return this;
  }
}
