// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulationPayloadDto _$SimulationPayloadDtoFromJson(
  Map<String, dynamic> json,
) => SimulationPayloadDto(
  productDescription: json['product_description'] as String,
  targetSegment: json['target_segment'] as String,
  panelSize: (json['panel_size'] as num).toInt(),
  journeyStages: (json['journey_stages'] as List<dynamic>)
      .map((e) => JourneyStageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SimulationPayloadDtoToJson(
  SimulationPayloadDto instance,
) => <String, dynamic>{
  'product_description': instance.productDescription,
  'target_segment': instance.targetSegment,
  'panel_size': instance.panelSize,
  'journey_stages': instance.journeyStages,
};
