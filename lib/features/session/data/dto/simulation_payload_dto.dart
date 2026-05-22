// To parse this JSON data, do
//
//     final simulationPayloadDto = simulationPayloadDtoFromJson(jsonString);

import 'package:crowdvise/features/session/data/dto/generated_journey_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'simulation_payload_dto.g.dart';

SimulationPayloadDto simulationPayloadDtoFromJson(String str) => SimulationPayloadDto.fromJson(json.decode(str));

String simulationPayloadDtoToJson(SimulationPayloadDto data) => json.encode(data.toJson());

@JsonSerializable()
class SimulationPayloadDto {
    @JsonKey(name: "product_description")
    String productDescription;
    @JsonKey(name: "target_segment")
    String targetSegment;
    @JsonKey(name: "panel_size")
    int panelSize;
    @JsonKey(name: "journey_stages")
    List<JourneyStageDto> journeyStages;

    SimulationPayloadDto({
        required this.productDescription,
        required this.targetSegment,
        required this.panelSize,
        required this.journeyStages,
    });

    factory SimulationPayloadDto.fromJson(Map<String, dynamic> json) => _$SimulationPayloadDtoFromJson(json);

    Map<String, dynamic> toJson() => _$SimulationPayloadDtoToJson(this);
}
