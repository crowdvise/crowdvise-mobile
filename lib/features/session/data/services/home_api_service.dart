import 'package:crowdvise/core/domain/utils/constants.dart';
import 'package:crowdvise/features/session/data/dto/generate_journey_payload_dto.dart';
import 'package:crowdvise/features/session/data/dto/generated_journey_dto.dart';
import 'package:crowdvise/features/session/data/dto/simulation_dto.dart';
import 'package:crowdvise/features/session/data/dto/simulation_payload_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api_service.g.dart';

@RestApi(baseUrl: crowdviseBaseUrl)
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  static const authentication = 'Authorization';

  @POST('simulation/generate-stages')
  Future<GeneratedJourneyDto> generateJourney({
    @Header(authentication) required String token,
    @Body() required GenerateJourneyPayloadDto payload,
  });

  @POST('simulation/run')
  Future<SimulationDto> runSimulation({
    @Header(authentication) required String token,
    @Body() required SimulationPayloadDto payload,
  });


}
