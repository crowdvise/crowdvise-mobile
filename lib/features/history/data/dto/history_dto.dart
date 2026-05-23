// To parse this JSON data, do
//
//     final historyDto = historyDtoFromJson(jsonString);

import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'history_dto.g.dart';

HistoryDto historyDtoFromJson(String str) => HistoryDto.fromJson(json.decode(str));

String historyDtoToJson(HistoryDto data) => json.encode(data.toJson());

@JsonSerializable()
class HistoryDto {
    @JsonKey(name: "runs")
    List<RunDto> runs;

    HistoryDto({
        required this.runs,
    });

    HistoryModel toDto(){
      return HistoryModel(
        runs: runs.map((item)=>item.toDto()).toList(),
      );
    }

    factory HistoryDto.fromJson(Map<String, dynamic> json) => _$HistoryDtoFromJson(json);

    Map<String, dynamic> toJson() => _$HistoryDtoToJson(this);
}

@JsonSerializable()
class RunDto {
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "product_description")
    String productDescription;
    @JsonKey(name: "target_segment")
    String targetSegment;
    @JsonKey(name: "panel_size")
    int panelSize;
    @JsonKey(name: "overall_conversion_rate")
    double overallConversionRate;
    @JsonKey(name: "overall_dropout_rate")
    double overallDropoutRate;
    @JsonKey(name: "overall_delayed_rate")
    double overallDelayedRate;
    @JsonKey(name: "readiness_score")
    int readinessScore;
    @JsonKey(name: "created_at")
    String createdAt;

    RunDto({
        required this.id,
        required this.productDescription,
        required this.targetSegment,
        required this.panelSize,
        required this.overallConversionRate,
        required this.overallDropoutRate,
        required this.overallDelayedRate,
        required this.readinessScore,
        required this.createdAt,
    });

    RunModel toDto(){
      return RunModel(
        id: id,
        productDescription: productDescription,
        targetSegment: targetSegment,
        panelSize: panelSize,
        overallConversionRate: overallConversionRate,
        overallDropoutRate: overallDropoutRate,
        overallDelayedRate: overallDelayedRate,
        readinessScore: readinessScore,
        createdAt: createdAt,
      );
    }

    factory RunDto.fromJson(Map<String, dynamic> json) => _$RunDtoFromJson(json);

    Map<String, dynamic> toJson() => _$RunDtoToJson(this);
}
