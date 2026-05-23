import 'package:crowdvise/core/domain/utils/constants.dart';
import 'package:crowdvise/features/history/data/dto/history_dto.dart';
import 'package:crowdvise/features/session/data/dto/simulation_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'history_api_service.g.dart';

@RestApi(baseUrl: crowdviseBaseUrl)
abstract class HistoryApiService {
  factory HistoryApiService(Dio dio, {String baseUrl}) = _HistoryApiService;

  static const authentication = 'Authorization';

  @GET('simulation/history')
  Future<HistoryDto> getHistory({
    @Header(authentication) required String token,
  });

  @GET('simulation/{id}')
  Future<SimulationDto> getPastSimulation({
    @Header(authentication) required String token,
    @Path('id') required String simulationId,
  });
}
