
import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/features/session/data/services/home_api_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class HomeModule {
  HomeApiService get api => HomeApiService(getIt.get<Dio>());
}