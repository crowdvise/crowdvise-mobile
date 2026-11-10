// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulationDto _$SimulationDtoFromJson(Map<String, dynamic> json) =>
    SimulationDto(
      simulationId: jsonString(json['simulation_id']),
      overallConversionRate: jsonDouble(json['overall_conversion_rate']),
      overallDropoutRate: jsonDouble(json['overall_dropout_rate']),
      overallDelayedRate: jsonDouble(json['overall_delayed_rate']),
      agentJourneys: _journeys(json['agent_journeys']),
      stageInsights: _stages(json['stage_insights']),
      topInsights: jsonStringList(json['top_insights']),
      readinessScore: jsonInt(json['readiness_score']),
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
      agent: _agent(json['agent']),
      reactions: _reactions(json['reactions']),
      finalOutcome: jsonString(json['final_outcome']),
      droppedAtStage: jsonStringOrNull(json['dropped_at_stage']),
    );

Map<String, dynamic> _$AgentJourneyDtoToJson(AgentJourneyDto instance) =>
    <String, dynamic>{
      'agent': instance.agent,
      'reactions': instance.reactions,
      'final_outcome': instance.finalOutcome,
      'dropped_at_stage': instance.droppedAtStage,
    };

AgentDto _$AgentDtoFromJson(Map<String, dynamic> json) => AgentDto(
  id: jsonString(json['id']),
  name: jsonString(json['name']),
  age: jsonInt(json['age']),
  gender: jsonString(json['gender']),
  location: jsonString(json['location']),
  incomeBracket: jsonString(json['income_bracket']),
  decisionStyle: jsonString(json['decision_style']),
  frictionThreshold: jsonInt(json['friction_threshold']),
  backstory: jsonString(json['backstory']),
  ocean: _ocean(json['ocean']),
  statusQuoTendency: jsonDouble(json['status_quo_tendency']),
  triggerSensitivities: _triggers(json['trigger_sensitivities']),
  lifestyleNotes: jsonString(json['lifestyle_notes']),
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
  openness: jsonDouble(json['openness']),
  conscientiousness: jsonDouble(json['conscientiousness']),
  extraversion: jsonDouble(json['extraversion']),
  agreeableness: jsonDouble(json['agreeableness']),
  neuroticism: jsonDouble(json['neuroticism']),
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
  unexpectedCost: jsonDouble(json['unexpected_cost']),
  trustViolation: jsonDouble(json['trust_violation']),
  cognitiveLoad: jsonDouble(json['cognitive_load']),
  effortCost: jsonDouble(json['effort_cost']),
  valueMismatch: jsonDouble(json['value_mismatch']),
  statusQuoInertia: jsonDouble(json['status_quo_inertia']),
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
  stageOrder: jsonInt(json['stage_order']),
  stageName: jsonString(json['stage_name']),
  behaviour: jsonString(json['behaviour']),
  internalMonologue: jsonString(json['internal_monologue']),
  frictionTriggered: jsonStringOrNull(json['friction_triggered']),
  frictionCost: jsonInt(json['friction_cost']),
  remainingThreshold: jsonInt(json['remaining_threshold']),
  whatWouldChangeThis: jsonStringOrNull(json['what_would_change_this']),
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
      stageName: jsonString(json['stage_name']),
      dropoutRate: jsonDouble(json['dropout_rate']),
      delayRate: jsonDouble(json['delay_rate']),
      topFrictionTrigger: jsonStringOrNull(json['top_friction_trigger']),
      confusionRate: jsonInt(json['confusion_rate']),
    );

Map<String, dynamic> _$StageInsightDtoToJson(StageInsightDto instance) =>
    <String, dynamic>{
      'stage_name': instance.stageName,
      'dropout_rate': instance.dropoutRate,
      'delay_rate': instance.delayRate,
      'top_friction_trigger': instance.topFrictionTrigger,
      'confusion_rate': instance.confusionRate,
    };
