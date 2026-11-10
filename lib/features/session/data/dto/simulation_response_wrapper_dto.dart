import 'package:crowdvise/core/data/json_helpers.dart';
import 'package:crowdvise/features/session/data/dto/generated_journey_dto.dart';
import 'package:crowdvise/features/session/data/dto/simulation_dto.dart';
import 'package:crowdvise/features/session/domain/models/simulation_response_wrapper_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simulation_response_wrapper_dto.g.dart';

List<JourneyStageDto> _stages(Object? v) =>
    jsonMapList(v).map(JourneyStageDto.fromJson).toList();

/// Wrapper returned by POST /simulation/run and POST .../test-fix.
/// `experiment_id` here is what every fix/compare call needs — not
/// `result.simulation_id`.
@JsonSerializable()
class SimulationResponseWrapperDto {
  @JsonKey(name: "result")
  SimulationDto result;

  @JsonKey(name: "experiment_id", fromJson: jsonString)
  String experimentId;

  @JsonKey(name: "run_kind", fromJson: jsonString)
  String runKind;

  @JsonKey(name: "reruns_remaining", fromJson: jsonInt)
  int rerunsRemaining;

  @JsonKey(name: "journey_stages", fromJson: _stages)
  List<JourneyStageDto> journeyStages;

  SimulationResponseWrapperDto({
    required this.result,
    required this.experimentId,
    required this.runKind,
    required this.rerunsRemaining,
    required this.journeyStages,
  });

  SimulationResponseWrapperModel toModel() {
    return SimulationResponseWrapperModel(
      result: result.toDto(),
      experimentId: experimentId,
      runKind: runKind,
      rerunsRemaining: rerunsRemaining,
      journeyStages: journeyStages.map((e) => e.toDto()).toList(),
    );
  }

  factory SimulationResponseWrapperDto.fromJson(Map<String, dynamic> json) =>
      _$SimulationResponseWrapperDtoFromJson(_normalize(json));

  /// POST /simulation/run returns the simulation object at the top level,
  /// while .../test-fix returns it nested under `result`. Normalise both so a
  /// live run and a re-run parse the same way.
  static Map<String, dynamic> _normalize(Map<String, dynamic> json) {
    final raw = json['result'];
    final result = raw is Map<String, dynamic> ? raw : json;
    final reruns = json['reruns_remaining'] ?? result['reruns_remaining'];
    return <String, dynamic>{
      'result': result,
      'experiment_id': json['experiment_id'] ??
          result['experiment_id'] ??
          result['simulation_id'],
      'run_kind': json['run_kind'] ?? result['run_kind'] ?? 'baseline',
      'reruns_remaining': reruns ?? 2,
      'journey_stages': json['journey_stages'] ?? result['journey_stages'],
    };
  }

  Map<String, dynamic> toJson() => _$SimulationResponseWrapperDtoToJson(this);
}
