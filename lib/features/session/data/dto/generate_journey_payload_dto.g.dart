// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_journey_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateJourneyPayloadDto _$GenerateJourneyPayloadDtoFromJson(
  Map<String, dynamic> json,
) => GenerateJourneyPayloadDto(
  productDescription: json['product_description'] as String,
  testScenario: json['test_scenario'] as String,
  targetSegment: json['target_segment'] as String,
);

Map<String, dynamic> _$GenerateJourneyPayloadDtoToJson(
  GenerateJourneyPayloadDto instance,
) => <String, dynamic>{
  'product_description': instance.productDescription,
  'test_scenario': instance.testScenario,
  'target_segment': instance.targetSegment,
};
