import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/use_case/use_case.dart';
import 'package:crowdvise/features/session/domain/models/generate_journey_payload.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/domain/repository/session_repository.dart';

class GenerateJourneyUsecase implements UseCase<GeneratedJourneyModel, GenerateJourneyPayload> {
  late final SessionRepository repository;
  late final GenerateJourneyPayload _param;

  GenerateJourneyUsecase(this.repository, this._param);

  @override
  Future<ApiResult<GeneratedJourneyModel>> invoke() {
    return repository.generateJourney(payload: _param);
  }

  @override
  GenerateJourneyPayload get param => _param;
}
