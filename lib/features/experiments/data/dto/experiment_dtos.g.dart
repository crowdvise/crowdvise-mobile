// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestFixesResponseDto _$SuggestFixesResponseDtoFromJson(
  Map<String, dynamic> json,
) => SuggestFixesResponseDto(
  fixes: (json['fixes'] as List<dynamic>)
      .map((e) => FixSuggestionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  rerunsRemaining: jsonInt(json['reruns_remaining']),
);

Map<String, dynamic> _$SuggestFixesResponseDtoToJson(
  SuggestFixesResponseDto instance,
) => <String, dynamic>{
  'fixes': instance.fixes,
  'reruns_remaining': instance.rerunsRemaining,
};

FixSuggestionDto _$FixSuggestionDtoFromJson(Map<String, dynamic> json) =>
    FixSuggestionDto(
      id: jsonString(json['id']),
      title: jsonString(json['title']),
      rationale: jsonString(json['rationale']),
      targetStageName: jsonString(json['target_stage_name']),
      originalDescription: jsonString(json['original_description']),
      patchedDescription: jsonString(json['patched_description']),
      expectedImpact: jsonString(json['expected_impact']),
    );

Map<String, dynamic> _$FixSuggestionDtoToJson(FixSuggestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'rationale': instance.rationale,
      'target_stage_name': instance.targetStageName,
      'original_description': instance.originalDescription,
      'patched_description': instance.patchedDescription,
      'expected_impact': instance.expectedImpact,
    };

PreviewFixRequestDto _$PreviewFixRequestDtoFromJson(
  Map<String, dynamic> json,
) => PreviewFixRequestDto(fixId: jsonString(json['fix_id']));

Map<String, dynamic> _$PreviewFixRequestDtoToJson(
  PreviewFixRequestDto instance,
) => <String, dynamic>{'fix_id': instance.fixId};

PreviewFixResponseDto _$PreviewFixResponseDtoFromJson(
  Map<String, dynamic> json,
) => PreviewFixResponseDto(
  fix: FixSuggestionDto.fromJson(json['fix'] as Map<String, dynamic>),
  journeyBefore: (json['journey_before'] as List<dynamic>)
      .map((e) => JourneyStageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  journeyAfter: (json['journey_after'] as List<dynamic>)
      .map((e) => JourneyStageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PreviewFixResponseDtoToJson(
  PreviewFixResponseDto instance,
) => <String, dynamic>{
  'fix': instance.fix,
  'journey_before': instance.journeyBefore,
  'journey_after': instance.journeyAfter,
};

TestFixRequestDto _$TestFixRequestDtoFromJson(Map<String, dynamic> json) =>
    TestFixRequestDto(fixId: jsonString(json['fix_id']));

Map<String, dynamic> _$TestFixRequestDtoToJson(TestFixRequestDto instance) =>
    <String, dynamic>{'fix_id': instance.fixId};

CompareExperimentResponseDto _$CompareExperimentResponseDtoFromJson(
  Map<String, dynamic> json,
) => CompareExperimentResponseDto(
  experimentId: jsonString(json['experiment_id']),
  runs: (json['runs'] as List<dynamic>)
      .map((e) => ExperimentRunDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  rerunsRemaining: jsonInt(json['reruns_remaining']),
);

Map<String, dynamic> _$CompareExperimentResponseDtoToJson(
  CompareExperimentResponseDto instance,
) => <String, dynamic>{
  'experiment_id': instance.experimentId,
  'runs': instance.runs,
  'reruns_remaining': instance.rerunsRemaining,
};

ExperimentRunDto _$ExperimentRunDtoFromJson(Map<String, dynamic> json) =>
    ExperimentRunDto(
      runId: jsonString(json['run_id']),
      runKind: jsonString(json['run_kind']),
      runIndex: jsonInt(json['run_index']),
      appliedFix: json['applied_fix'] == null
          ? null
          : FixSuggestionDto.fromJson(
              json['applied_fix'] as Map<String, dynamic>,
            ),
      overallConversionRate: jsonDouble(json['overall_conversion_rate']),
      overallDropoutRate: jsonDouble(json['overall_dropout_rate']),
      overallDelayedRate: jsonDouble(json['overall_delayed_rate']),
      readinessScore: jsonInt(json['readiness_score']),
      readinessLevel: jsonString(json['readiness_level']),
    );

Map<String, dynamic> _$ExperimentRunDtoToJson(ExperimentRunDto instance) =>
    <String, dynamic>{
      'run_id': instance.runId,
      'run_kind': instance.runKind,
      'run_index': instance.runIndex,
      'applied_fix': instance.appliedFix,
      'overall_conversion_rate': instance.overallConversionRate,
      'overall_dropout_rate': instance.overallDropoutRate,
      'overall_delayed_rate': instance.overallDelayedRate,
      'readiness_score': instance.readinessScore,
      'readiness_level': instance.readinessLevel,
    };
