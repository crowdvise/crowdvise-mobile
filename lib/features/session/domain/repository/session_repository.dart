import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/features/session/domain/models/generate_journey_payload.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_payload.dart';

abstract class SessionRepository {
  Future<ApiResult<SimulationModel>> runSimulation({
    required SimulationPayload payload,
  });
  Future<ApiResult<GeneratedJourneyModel>> generateJourney({
    required GenerateJourneyPayload payload,
  });
}
