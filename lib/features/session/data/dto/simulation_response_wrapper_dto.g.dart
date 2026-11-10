// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation_response_wrapper_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulationResponseWrapperDto _$SimulationResponseWrapperDtoFromJson(
  Map<String, dynamic> json,
) => SimulationResponseWrapperDto(
  result: SimulationDto.fromJson(json['result'] as Map<String, dynamic>),
  experimentId: jsonString(json['experiment_id']),
  runKind: jsonString(json['run_kind']),
  rerunsRemaining: jsonInt(json['reruns_remaining']),
  journeyStages: _stages(json['journey_stages']),
);

Map<String, dynamic> _$SimulationResponseWrapperDtoToJson(
  SimulationResponseWrapperDto instance,
) => <String, dynamic>{
  'result': instance.result,
  'experiment_id': instance.experimentId,
  'run_kind': instance.runKind,
  'reruns_remaining': instance.rerunsRemaining,
  'journey_stages': instance.journeyStages,
};
