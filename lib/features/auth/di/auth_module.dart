
import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/features/auth/data/services/auth_api_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AuthModule {
  AuthApiService get api => AuthApiService(getIt.get<Dio>());
}