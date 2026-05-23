import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/features/history/data/services/history_api_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class HistoryModule {
  HistoryApiService get api => HistoryApiService(getIt.get<Dio>());
}
