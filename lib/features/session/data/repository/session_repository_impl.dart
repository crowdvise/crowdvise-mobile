import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/core/presentation/utils/util_functions.dart';
import 'package:crowdvise/features/experiments/data/dto/experiment_dtos.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/features/session/domain/models/simulation_response_wrapper_model.dart';
import 'package:crowdvise/features/session/data/dto/generate_journey_payload_dto.dart';
import 'package:crowdvise/features/session/data/dto/generated_journey_dto.dart';
import 'package:crowdvise/features/session/data/dto/simulation_payload_dto.dart';
import 'package:crowdvise/features/session/data/services/session_api_service.dart';
import 'package:crowdvise/features/session/domain/models/generate_journey_payload.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_payload.dart';
import 'package:crowdvise/features/session/domain/repository/session_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  final api = getIt.get<SessionApiService>();

  @override
  Future<ApiResult<GeneratedJourneyModel>> generateJourney({
    required GenerateJourneyPayload payload,
  }) async {
    try {
      final param = GenerateJourneyPayloadDto(
        productDescription: payload.productDescription,
        testScenario: payload.testScenario,
        targetSegment: payload.targetSegment,
      );
      final result = await api.generateJourney(
        payload: param,
        token: accessToken,
      );
      return ApiResult.success(result.toDto());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }
// A $50 jollof rice meal kit for Downtown Toronto professionals. Pre-measured spices, 45 min recipe, ships nationwide in Canada.
// Will customers pay this price when they see it on the product page?
// Millennials in Greater Toronto, 28–40, cook at home 3x/week
  @override
  Future<ApiResult<SimulationResponseWrapperModel>> runSimulation({
    required SimulationPayload payload,
  }) async {
     try {
    final param = SimulationPayloadDto(
      productDescription: payload.productDescription,
      targetSegment: payload.targetSegment,
      panelSize: payload.panelSize,
      journeyStages: payload.journeyStages
          .map(
            (e) => JourneyStageDto(
              order: e.order,
              name: e.name,
              description: e.description,
            ),
          )
          .toList(),
    );
    final result = await api.runSimulation(payload: param, token: accessToken);
    // logg(result.toString());
    // logg("success!");
    return ApiResult.success(result.toModel());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  @override
  Future<ApiResult<SuggestFixesResponse>> suggestFixes({
    required String experimentId,
  }) async {
    try {
      final result = await api.suggestFixes(token: accessToken, experimentId: experimentId);
      return ApiResult.success(result.toModel());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  @override
  Future<ApiResult<PreviewFixResponse>> previewFix({
    required String experimentId,
    required String fixId,
  }) async {
    try {
      final param = PreviewFixRequestDto(fixId: fixId);
      final result = await api.previewFix(token: accessToken, experimentId: experimentId, payload: param);
      return ApiResult.success(result.toModel());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  @override
  Future<ApiResult<SimulationResponseWrapperModel>> testFix({
    required String experimentId,
    required String fixId,
  }) async {
    try {
      final param = TestFixRequestDto(fixId: fixId);
      final result = await api.testFix(token: accessToken, experimentId: experimentId, payload: param);
      return ApiResult.success(result.toModel());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  @override
  Future<ApiResult<CompareExperimentResponse>> getExperimentRuns({
    required String experimentId,
  }) async {
    try {
      final result = await api.getExperimentRuns(token: accessToken, experimentId: experimentId);
      return ApiResult.success(result.toModel());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }
}
