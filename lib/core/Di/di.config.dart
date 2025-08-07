// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/data_source_contract/auth/login_datasource.dart' as _i1048;
import '../../data/data_source_contract/auth/register_datasource.dart' as _i504;
import '../../data/data_source_contract/auth/signin_with_facebook_datasource.dart'
    as _i489;
import '../../data/data_source_contract/auth/signin_with_google_datasource.dart'
    as _i574;
import '../../data/data_source_impl/auth/login_datasource_impl.dart' as _i1013;
import '../../data/data_source_impl/auth/register_datasource_impl.dart'
    as _i112;
import '../../data/data_source_impl/auth/signin_with_facebook_datasource_impl.dart'
    as _i216;
import '../../data/data_source_impl/auth/signin_with_google_datasource_impl.dart'
    as _i424;
import '../../data/repo_impl/auth/login_repo_impl.dart' as _i314;
import '../../data/repo_impl/auth/register_repo_impl.dart' as _i853;
import '../../data/repo_impl/auth/signin_with_facebook_repo_impl.dart' as _i28;
import '../../data/repo_impl/auth/signin_with_google_repo_impl.dart' as _i27;
import '../../domain/repo_contract/auth/login_repo.dart' as _i284;
import '../../domain/repo_contract/auth/register_repo.dart' as _i911;
import '../../domain/repo_contract/auth/signin_with_facebook_repo.dart'
    as _i301;
import '../../domain/repo_contract/auth/signin_with_google_repo.dart' as _i81;
import '../../domain/use_cases/auth/login_usecase.dart' as _i912;
import '../../domain/use_cases/auth/register_usecase.dart' as _i954;
import '../../domain/use_cases/auth/signin_with_facebook_usecase.dart' as _i441;
import '../../domain/use_cases/auth/signin_with_google_usecase.dart' as _i299;
import '../../ui/auth/view_model/auth_cubit.dart' as _i538;
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
    gh.singleton<_i1025.FirebaseManager>(() => _i1025.FirebaseManager());
    gh.factory<_i504.RegisterDatasource>(
        () => _i112.RegisterDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i574.SigninWithGoogleDatasource>(() =>
        _i424.SigninWithGoogleDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i911.RegisterRepo>(
        () => _i853.RegisterRepoImpl(gh<_i504.RegisterDatasource>()));
    gh.factory<_i489.SigninWithFacebookDatasource>(() =>
        _i216.SigninWithFacebookDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i1048.LoginDatasource>(
        () => _i1013.LoginDatasourceImpl(gh<_i1025.FirebaseManager>()));
    gh.factory<_i81.SigninWithGoogleRepo>(() =>
        _i27.SigninWithGoogleRepoImpl(gh<_i574.SigninWithGoogleDatasource>()));
    gh.factory<_i299.SigninWithGoogleUsecase>(
        () => _i299.SigninWithGoogleUsecase(gh<_i81.SigninWithGoogleRepo>()));
    gh.factory<_i284.LoginRepo>(
        () => _i314.LoginRepoImpl(gh<_i1048.LoginDatasource>()));
    gh.factory<_i912.LoginUseCase>(
        () => _i912.LoginUseCase(gh<_i284.LoginRepo>()));
    gh.factory<_i954.RegisterUsecase>(
        () => _i954.RegisterUsecase(gh<_i911.RegisterRepo>()));
    gh.factory<_i301.SigninWithFacebookRepo>(() =>
        _i28.SigninWithFacebookRepoImpl(
            gh<_i489.SigninWithFacebookDatasource>()));
    gh.factory<_i441.SigninWithFacebookUsecase>(() =>
        _i441.SigninWithFacebookUsecase(gh<_i301.SigninWithFacebookRepo>()));
    gh.factory<_i538.AuthCubit>(() => _i538.AuthCubit(
          gh<_i912.LoginUseCase>(),
          gh<_i954.RegisterUsecase>(),
          gh<_i299.SigninWithGoogleUsecase>(),
          gh<_i441.SigninWithFacebookUsecase>(),
        ));
    return this;
  }
}
