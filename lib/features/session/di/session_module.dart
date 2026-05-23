import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/features/session/data/services/session_api_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class SessionModule {
  SessionApiService get api => SessionApiService(getIt.get<Dio>());
}
