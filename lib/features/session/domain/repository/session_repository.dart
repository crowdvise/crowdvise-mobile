import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/features/session/domain/models/generate_journey_payload.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_payload.dart';
import 'package:crowdvise/features/session/domain/models/simulation_response_wrapper_model.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';

abstract class SessionRepository {
  Future<ApiResult<SimulationResponseWrapperModel>> runSimulation({
    required SimulationPayload payload,
  });
  Future<ApiResult<GeneratedJourneyModel>> generateJourney({
    required GenerateJourneyPayload payload,
  });
  Future<ApiResult<SuggestFixesResponse>> suggestFixes({
    required String experimentId,
  });
  Future<ApiResult<PreviewFixResponse>> previewFix({
    required String experimentId,
    required String fixId,
  });
  Future<ApiResult<SimulationResponseWrapperModel>> testFix({
    required String experimentId,
    required String fixId,
  });
  Future<ApiResult<CompareExperimentResponse>> getExperimentRuns({
    required String experimentId,
  });
}
