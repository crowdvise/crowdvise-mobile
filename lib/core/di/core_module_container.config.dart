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
import 'package:crowdvise/features/history/data/repository/history_repository_impl.dart'
    as _i132;
import 'package:crowdvise/features/history/data/services/history_api_service.dart'
    as _i646;
import 'package:crowdvise/features/history/di/history_module.dart' as _i1072;
import 'package:crowdvise/features/history/domain/repository/history_repository.dart'
    as _i404;
import 'package:crowdvise/features/session/data/repository/session_repository_impl.dart'
    as _i410;
import 'package:crowdvise/features/session/data/services/session_api_service.dart'
    as _i422;
import 'package:crowdvise/features/session/di/session_module.dart' as _i118;
import 'package:crowdvise/features/session/domain/repository/session_repository.dart'
    as _i632;
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
    final historyModule = _$HistoryModule();
    final sessionModule = _$SessionModule();
    gh.factory<_i361.Dio>(() => coreModule.dio());
    gh.factoryAsync<_i460.SharedPreferences>(() => coreModule.preferences());
    gh.factory<_i1055.AuthApiService>(() => authModule.api);
    gh.factory<_i646.HistoryApiService>(() => historyModule.api);
    gh.factory<_i422.SessionApiService>(() => sessionModule.api);
    gh.lazySingleton<_i632.SessionRepository>(
      () => _i410.SessionRepositoryImpl(),
    );
    gh.lazySingleton<_i404.HistoryRepository>(
      () => _i132.HistoryRepositoryImpl(),
    );
    gh.lazySingleton<_i667.AuthRepository>(() => _i335.AuthRepositoryImpl());
    return this;
  }
}

class _$CoreModule extends _i417.CoreModule {}

class _$AuthModule extends _i562.AuthModule {}

class _$HistoryModule extends _i1072.HistoryModule {}

class _$SessionModule extends _i118.SessionModule {}
