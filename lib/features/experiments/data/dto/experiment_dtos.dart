import 'package:crowdvise/features/session/data/dto/generated_journey_dto.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/core/data/json_helpers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'experiment_dtos.g.dart';

@JsonSerializable()
class SuggestFixesResponseDto {
  @JsonKey(name: "fixes")
  List<FixSuggestionDto> fixes;
  @JsonKey(name: "reruns_remaining", fromJson: jsonInt)
  int rerunsRemaining;

  SuggestFixesResponseDto({required this.fixes, required this.rerunsRemaining});

  SuggestFixesResponse toModel() => SuggestFixesResponse(
        fixes: fixes.map((e) => e.toModel()).toList(),
        rerunsRemaining: rerunsRemaining,
      );

  factory SuggestFixesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SuggestFixesResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestFixesResponseDtoToJson(this);
}

@JsonSerializable()
class FixSuggestionDto {
  @JsonKey(name: "id", fromJson: jsonString)
  String id;
  @JsonKey(name: "title", fromJson: jsonString)
  String title;
  @JsonKey(name: "rationale", fromJson: jsonString)
  String rationale;
  @JsonKey(name: "target_stage_name", fromJson: jsonString)
  String targetStageName;
  @JsonKey(name: "original_description", fromJson: jsonString)
  String originalDescription;
  @JsonKey(name: "patched_description", fromJson: jsonString)
  String patchedDescription;
  @JsonKey(name: "expected_impact", fromJson: jsonString)
  String expectedImpact;

  FixSuggestionDto({
    required this.id,
    required this.title,
    required this.rationale,
    required this.targetStageName,
    required this.originalDescription,
    required this.patchedDescription,
    required this.expectedImpact,
  });

  FixSuggestion toModel() => FixSuggestion(
        id: id,
        title: title,
        rationale: rationale,
        targetStageName: targetStageName,
        originalDescription: originalDescription,
        patchedDescription: patchedDescription,
        expectedImpact: expectedImpact,
      );

  factory FixSuggestionDto.fromJson(Map<String, dynamic> json) =>
      _$FixSuggestionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FixSuggestionDtoToJson(this);
}

@JsonSerializable()
class PreviewFixRequestDto {
  @JsonKey(name: "fix_id", fromJson: jsonString)
  String fixId;

  PreviewFixRequestDto({required this.fixId});

  factory PreviewFixRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PreviewFixRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PreviewFixRequestDtoToJson(this);
}

@JsonSerializable()
class PreviewFixResponseDto {
  @JsonKey(name: "fix")
  FixSuggestionDto fix;
  @JsonKey(name: "journey_before")
  List<JourneyStageDto> journeyBefore;
  @JsonKey(name: "journey_after")
  List<JourneyStageDto> journeyAfter;

  PreviewFixResponseDto({
    required this.fix,
    required this.journeyBefore,
    required this.journeyAfter,
  });

  PreviewFixResponse toModel() => PreviewFixResponse(
        fix: fix.toModel(),
        journeyBefore: journeyBefore.map((e) => e.toDto()).toList(),
        journeyAfter: journeyAfter.map((e) => e.toDto()).toList(),
      );

  factory PreviewFixResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PreviewFixResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PreviewFixResponseDtoToJson(this);
}

@JsonSerializable()
class TestFixRequestDto {
  @JsonKey(name: "fix_id", fromJson: jsonString)
  String fixId;

  TestFixRequestDto({required this.fixId});

  factory TestFixRequestDto.fromJson(Map<String, dynamic> json) =>
      _$TestFixRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TestFixRequestDtoToJson(this);
}

@JsonSerializable()
class CompareExperimentResponseDto {
  @JsonKey(name: "experiment_id", fromJson: jsonString)
  String experimentId;
  @JsonKey(name: "runs")
  List<ExperimentRunDto> runs;
  @JsonKey(name: "reruns_remaining", fromJson: jsonInt)
  int rerunsRemaining;

  CompareExperimentResponseDto({
    required this.experimentId,
    required this.runs,
    required this.rerunsRemaining,
  });

  CompareExperimentResponse toModel() => CompareExperimentResponse(
        experimentId: experimentId,
        runs: runs.map((e) => e.toModel()).toList(),
        rerunsRemaining: rerunsRemaining,
      );

  factory CompareExperimentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CompareExperimentResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CompareExperimentResponseDtoToJson(this);
}

@JsonSerializable()
class ExperimentRunDto {
  @JsonKey(name: "run_id", fromJson: jsonString)
  String runId;
  @JsonKey(name: "run_kind", fromJson: jsonString)
  String runKind;
  @JsonKey(name: "run_index", fromJson: jsonInt)
  int runIndex;
  @JsonKey(name: "applied_fix")
  FixSuggestionDto? appliedFix;
  @JsonKey(name: "overall_conversion_rate", fromJson: jsonDouble)
  double overallConversionRate;
  @JsonKey(name: "overall_dropout_rate", fromJson: jsonDouble)
  double overallDropoutRate;
  @JsonKey(name: "overall_delayed_rate", fromJson: jsonDouble)
  double overallDelayedRate;
  @JsonKey(name: "readiness_score", fromJson: jsonInt)
  int readinessScore;
  @JsonKey(name: "readiness_level", fromJson: jsonString)
  String readinessLevel;

  ExperimentRunDto({
    required this.runId,
    required this.runKind,
    required this.runIndex,
    required this.appliedFix,
    required this.overallConversionRate,
    required this.overallDropoutRate,
    required this.overallDelayedRate,
    required this.readinessScore,
    required this.readinessLevel,
  });

  ExperimentRun toModel() => ExperimentRun(
        runId: runId,
        runKind: runKind,
        runIndex: runIndex,
        appliedFix: appliedFix?.toModel(),
        overallConversionRate: overallConversionRate,
        overallDropoutRate: overallDropoutRate,
        overallDelayedRate: overallDelayedRate,
        readinessScore: readinessScore,
        readinessLevel: readinessLevel,
      );

  factory ExperimentRunDto.fromJson(Map<String, dynamic> json) =>
      _$ExperimentRunDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ExperimentRunDtoToJson(this);
}
