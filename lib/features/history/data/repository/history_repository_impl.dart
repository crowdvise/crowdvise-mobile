import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/features/history/data/services/history_api_service.dart';
import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:crowdvise/features/history/domain/repository/history_repository.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final api = getIt.get<HistoryApiService>();

  @override
  Future<ApiResult<HistoryModel>> getHistory() async {
    try {
      final result = await api.getHistory(token: accessToken);
      return ApiResult.success(result.toDto());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }
  
  @override
  Future<ApiResult<SimulationModel>> getPastSimulation({required String simulationId}) async {
    try {
      final result = await api.getPastSimulation(token: accessToken,simulationId:simulationId );
      return ApiResult.success(result.toDto());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

 
}
