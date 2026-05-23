// To parse this JSON data, do
//
//     final generatedJourneyDto = generatedJourneyDtoFromJson(jsonString);

import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'generated_journey_dto.g.dart';

GeneratedJourneyDto generatedJourneyDtoFromJson(String str) =>
    GeneratedJourneyDto.fromJson(json.decode(str));

String generatedJourneyDtoToJson(GeneratedJourneyDto data) =>
    json.encode(data.toJson());

@JsonSerializable()
class GeneratedJourneyDto {
  @JsonKey(name: "suggested_stages")
  List<JourneyStageDto> suggestedStages;

  GeneratedJourneyDto({required this.suggestedStages});

  GeneratedJourneyModel toDto() => GeneratedJourneyModel(
    journeyStages: suggestedStages.map((e) => e.toDto()).toList(),
  );

  factory GeneratedJourneyDto.fromJson(Map<String, dynamic> json) =>
      _$GeneratedJourneyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratedJourneyDtoToJson(this);
}

@JsonSerializable()
class JourneyStageDto {
  @JsonKey(name: "order")
  int order;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "description")
  String description;

  JourneyStageDto({
    required this.order,
    required this.name,
    required this.description,
  });

  JourneyStageModel toDto() =>
      JourneyStageModel(order: order, name: name, description: description);

  factory JourneyStageDto.fromJson(Map<String, dynamic> json) =>
      _$JourneyStageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JourneyStageDtoToJson(this);
}
