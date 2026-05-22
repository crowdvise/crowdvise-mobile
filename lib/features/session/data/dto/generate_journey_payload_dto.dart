// To parse this JSON data, do
//
//     final generateJourneyPayloadDto = generateJourneyPayloadDtoFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'generate_journey_payload_dto.g.dart';

GenerateJourneyPayloadDto generateJourneyPayloadDtoFromJson(String str) => GenerateJourneyPayloadDto.fromJson(json.decode(str));

String generateJourneyPayloadDtoToJson(GenerateJourneyPayloadDto data) => json.encode(data.toJson());

@JsonSerializable()
class GenerateJourneyPayloadDto {
    @JsonKey(name: "product_description")
    String productDescription;
    @JsonKey(name: "test_scenario")
    String testScenario;
    @JsonKey(name: "target_segment")
    String targetSegment;

    GenerateJourneyPayloadDto({
        required this.productDescription,
        required this.testScenario,
        required this.targetSegment,
    });

    factory GenerateJourneyPayloadDto.fromJson(Map<String, dynamic> json) => _$GenerateJourneyPayloadDtoFromJson(json);

    Map<String, dynamic> toJson() => _$GenerateJourneyPayloadDtoToJson(this);
}
