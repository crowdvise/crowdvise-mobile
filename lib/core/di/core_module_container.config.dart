// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:crowdvise/core/di/core_module.dart' as _i417;
import 'package:crowdvise/features/auth/data/repository/auth_repository_impl.dart'
    as _i335;
import 'package:crowdvise/features/auth/data/services/auth_api_service.dart'
    as _i1055;
import 'package:crowdvise/features/auth/di/auth_module.dart' as _i562;
import 'package:crowdvise/features/auth/domain/repository/auth_repository.dart'
    as _i667;
import 'package:crowdvise/features/session/data/services/home_api_service.dart'
    as _i743;
import 'package:crowdvise/features/session/di/home_module.dart' as _i890;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    final authModule = _$AuthModule();
    final homeModule = _$HomeModule();
    gh.factory<_i361.Dio>(() => coreModule.dio());
    gh.factoryAsync<_i460.SharedPreferences>(() => coreModule.preferences());
    gh.factory<_i1055.AuthApiService>(() => authModule.api);
    gh.factory<_i743.HomeApiService>(() => homeModule.api);
    gh.lazySingleton<_i667.AuthRepository>(() => _i335.AuthRepositoryImpl());
    return this;
  }
}

class _$CoreModule extends _i417.CoreModule {}

class _$AuthModule extends _i562.AuthModule {}

class _$HomeModule extends _i890.HomeModule {}
