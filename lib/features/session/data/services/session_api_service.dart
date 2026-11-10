import 'package:crowdvise/core/domain/utils/constants.dart';
import 'package:crowdvise/features/session/data/dto/generate_journey_payload_dto.dart';
import 'package:crowdvise/features/session/data/dto/generated_journey_dto.dart';
import 'package:crowdvise/features/session/data/dto/simulation_payload_dto.dart';
import 'package:crowdvise/features/session/data/dto/simulation_response_wrapper_dto.dart';
import 'package:crowdvise/features/experiments/data/dto/experiment_dtos.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'session_api_service.g.dart';

@RestApi(baseUrl: crowdviseBaseUrl)
abstract class SessionApiService {
  factory SessionApiService(Dio dio, {String baseUrl}) = _SessionApiService;

  static const authentication = 'Authorization';

  @POST('simulation/generate-stages')
  Future<GeneratedJourneyDto> generateJourney({
    @Header(authentication) required String token,
    @Body() required GenerateJourneyPayloadDto payload,
  });

  @POST('simulation/run')
  Future<SimulationResponseWrapperDto> runSimulation({
    @Header(SessionApiService.authentication) required String token,
    @Body() required SimulationPayloadDto payload,
  });

  @POST('simulation/experiments/{id}/suggest-fixes')
  Future<SuggestFixesResponseDto> suggestFixes({
    @Header(SessionApiService.authentication) required String token,
    @Path('id') required String experimentId,
  });

  @POST('simulation/experiments/{id}/preview-fix')
  Future<PreviewFixResponseDto> previewFix({
    @Header(SessionApiService.authentication) required String token,
    @Path('id') required String experimentId,
    @Body() required PreviewFixRequestDto payload,
  });

  @POST('simulation/experiments/{id}/test-fix')
  Future<SimulationResponseWrapperDto> testFix({
    @Header(SessionApiService.authentication) required String token,
    @Path('id') required String experimentId,
    @Body() required TestFixRequestDto payload,
  });

  @GET('simulation/experiments/{id}')
  Future<CompareExperimentResponseDto> getExperimentRuns({
    @Header(SessionApiService.authentication) required String token,
    @Path('id') required String experimentId,
  });
}
