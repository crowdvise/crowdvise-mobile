import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';

abstract class HistoryRepository {
  Future<ApiResult<HistoryModel>> getHistory();
  Future<ApiResult<SimulationModel>> getPastSimulation({
    required String simulationId,
  });
}
