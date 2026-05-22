// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_journey_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneratedJourneyDto _$GeneratedJourneyDtoFromJson(Map<String, dynamic> json) =>
    GeneratedJourneyDto(
      suggestedStages: (json['suggested_stages'] as List<dynamic>)
          .map((e) => JourneyStageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GeneratedJourneyDtoToJson(
  GeneratedJourneyDto instance,
) => <String, dynamic>{'suggested_stages': instance.suggestedStages};

JourneyStageDto _$JourneyStageDtoFromJson(Map<String, dynamic> json) =>
    JourneyStageDto(
      order: (json['order'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$JourneyStageDtoToJson(JourneyStageDto instance) =>
    <String, dynamic>{
      'order': instance.order,
      'name': instance.name,
      'description': instance.description,
    };
