import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/use_case/use_case.dart';
import 'package:crowdvise/features/history/domain/repository/history_repository.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';

class GetPastSimulationUsecase implements UseCase<SimulationModel, String> {
  late final HistoryRepository repository;
  late final String _param;

  GetPastSimulationUsecase(this.repository, this._param);

  @override
  Future<ApiResult<SimulationModel>> invoke() {
    return repository.getPastSimulation(simulationId: _param);
  }

  @override
  String get param => _param;
}
