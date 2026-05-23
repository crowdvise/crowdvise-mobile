import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/use_case/use_case.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_payload.dart';
import 'package:crowdvise/features/session/domain/repository/session_repository.dart';

class RunSimulationUsecase implements UseCase<SimulationModel, SimulationPayload> {
  late final SessionRepository repository;
  late final SimulationPayload _param;

  RunSimulationUsecase(this.repository, this._param);

  @override
  Future<ApiResult<SimulationModel>> invoke() {
    return repository.runSimulation(payload: _param);
  }

  @override
  SimulationPayload get param => _param;
}
