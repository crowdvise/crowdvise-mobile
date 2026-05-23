// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulationDto _$SimulationDtoFromJson(Map<String, dynamic> json) =>
    SimulationDto(
      simulationId: json['simulation_id'] as String,
      overallConversionRate: (json['overall_conversion_rate'] as num)
          .toDouble(),
      overallDropoutRate: (json['overall_dropout_rate'] as num).toDouble(),
      overallDelayedRate: (json['overall_delayed_rate'] as num).toInt(),
      agentJourneys: (json['agent_journeys'] as List<dynamic>)
          .map((e) => AgentJourneyDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      stageInsights: (json['stage_insights'] as List<dynamic>)
          .map((e) => StageInsightDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      topInsights: (json['top_insights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      readinessScore: (json['readiness_score'] as num).toInt(),
    );

Map<String, dynamic> _$SimulationDtoToJson(SimulationDto instance) =>
    <String, dynamic>{
      'simulation_id': instance.simulationId,
      'overall_conversion_rate': instance.overallConversionRate,
      'overall_dropout_rate': instance.overallDropoutRate,
      'overall_delayed_rate': instance.overallDelayedRate,
      'agent_journeys': instance.agentJourneys,
      'stage_insights': instance.stageInsights,
      'top_insights': instance.topInsights,
      'readiness_score': instance.readinessScore,
    };

AgentJourneyDto _$AgentJourneyDtoFromJson(Map<String, dynamic> json) =>
    AgentJourneyDto(
      agent: AgentDto.fromJson(json['agent'] as Map<String, dynamic>),
      reactions: (json['reactions'] as List<dynamic>)
          .map((e) => ReactionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalOutcome: json['final_outcome'] as String,
      droppedAtStage: json['dropped_at_stage'] as String?,
    );

Map<String, dynamic> _$AgentJourneyDtoToJson(AgentJourneyDto instance) =>
    <String, dynamic>{
      'agent': instance.agent,
      'reactions': instance.reactions,
      'final_outcome': instance.finalOutcome,
      'dropped_at_stage': instance.droppedAtStage,
    };

AgentDto _$AgentDtoFromJson(Map<String, dynamic> json) => AgentDto(
  id: json['id'] as String,
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  gender: json['gender'] as String,
  location: json['location'] as String,
  incomeBracket: json['income_bracket'] as String,
  decisionStyle: json['decision_style'] as String,
  frictionThreshold: (json['friction_threshold'] as num).toInt(),
  backstory: json['backstory'] as String,
  ocean: OceanDto.fromJson(json['ocean'] as Map<String, dynamic>),
  statusQuoTendency: (json['status_quo_tendency'] as num).toDouble(),
  triggerSensitivities: TriggerSensitivitiesDto.fromJson(
    json['trigger_sensitivities'] as Map<String, dynamic>,
  ),
  lifestyleNotes: json['lifestyle_notes'] as String,
);

Map<String, dynamic> _$AgentDtoToJson(AgentDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
  'gender': instance.gender,
  'location': instance.location,
  'income_bracket': instance.incomeBracket,
  'decision_style': instance.decisionStyle,
  'friction_threshold': instance.frictionThreshold,
  'backstory': instance.backstory,
  'ocean': instance.ocean,
  'status_quo_tendency': instance.statusQuoTendency,
  'trigger_sensitivities': instance.triggerSensitivities,
  'lifestyle_notes': instance.lifestyleNotes,
};

OceanDto _$OceanDtoFromJson(Map<String, dynamic> json) => OceanDto(
  openness: (json['openness'] as num).toDouble(),
  conscientiousness: (json['conscientiousness'] as num).toDouble(),
  extraversion: (json['extraversion'] as num).toDouble(),
  agreeableness: (json['agreeableness'] as num).toDouble(),
  neuroticism: (json['neuroticism'] as num).toDouble(),
);

Map<String, dynamic> _$OceanDtoToJson(OceanDto instance) => <String, dynamic>{
  'openness': instance.openness,
  'conscientiousness': instance.conscientiousness,
  'extraversion': instance.extraversion,
  'agreeableness': instance.agreeableness,
  'neuroticism': instance.neuroticism,
};

TriggerSensitivitiesDto _$TriggerSensitivitiesDtoFromJson(
  Map<String, dynamic> json,
) => TriggerSensitivitiesDto(
  unexpectedCost: (json['unexpected_cost'] as num).toDouble(),
  trustViolation: (json['trust_violation'] as num).toDouble(),
  cognitiveLoad: (json['cognitive_load'] as num).toDouble(),
  effortCost: (json['effort_cost'] as num).toDouble(),
  valueMismatch: (json['value_mismatch'] as num).toDouble(),
  statusQuoInertia: (json['status_quo_inertia'] as num).toDouble(),
);

Map<String, dynamic> _$TriggerSensitivitiesDtoToJson(
  TriggerSensitivitiesDto instance,
) => <String, dynamic>{
  'unexpected_cost': instance.unexpectedCost,
  'trust_violation': instance.trustViolation,
  'cognitive_load': instance.cognitiveLoad,
  'effort_cost': instance.effortCost,
  'value_mismatch': instance.valueMismatch,
  'status_quo_inertia': instance.statusQuoInertia,
};

ReactionDto _$ReactionDtoFromJson(Map<String, dynamic> json) => ReactionDto(
  stageOrder: (json['stage_order'] as num).toInt(),
  stageName: json['stage_name'] as String,
  behaviour: json['behaviour'] as String,
  internalMonologue: json['internal_monologue'] as String,
  frictionTriggered: json['friction_triggered'] as String?,
  frictionCost: (json['friction_cost'] as num).toInt(),
  remainingThreshold: (json['remaining_threshold'] as num).toInt(),
  whatWouldChangeThis: json['what_would_change_this'] as String?,
);

Map<String, dynamic> _$ReactionDtoToJson(ReactionDto instance) =>
    <String, dynamic>{
      'stage_order': instance.stageOrder,
      'stage_name': instance.stageName,
      'behaviour': instance.behaviour,
      'internal_monologue': instance.internalMonologue,
      'friction_triggered': instance.frictionTriggered,
      'friction_cost': instance.frictionCost,
      'remaining_threshold': instance.remainingThreshold,
      'what_would_change_this': instance.whatWouldChangeThis,
    };

StageInsightDto _$StageInsightDtoFromJson(Map<String, dynamic> json) =>
    StageInsightDto(
      stageName: json['stage_name'] as String,
      dropoutRate: (json['dropout_rate'] as num).toDouble(),
      delayRate: (json['delay_rate'] as num).toDouble(),
      topFrictionTrigger: json['top_friction_trigger'] as String?,
      confusionRate: (json['confusion_rate'] as num).toInt(),
    );

Map<String, dynamic> _$StageInsightDtoToJson(StageInsightDto instance) =>
    <String, dynamic>{
      'stage_name': instance.stageName,
      'dropout_rate': instance.dropoutRate,
      'delay_rate': instance.delayRate,
      'top_friction_trigger': instance.topFrictionTrigger,
      'confusion_rate': instance.confusionRate,
    };
