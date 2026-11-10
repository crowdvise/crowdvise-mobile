import 'dart:convert';

import 'package:crowdvise/core/data/json_helpers.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simulation_dto.g.dart';

SimulationDto simulationDtoFromJson(String str) =>
    SimulationDto.fromJson(json.decode(str));

String simulationDtoToJson(SimulationDto data) => json.encode(data.toJson());

List<AgentJourneyDto> _journeys(Object? v) =>
    jsonMapList(v).map(AgentJourneyDto.fromJson).toList();
List<StageInsightDto> _stages(Object? v) =>
    jsonMapList(v).map(StageInsightDto.fromJson).toList();
List<ReactionDto> _reactions(Object? v) =>
    jsonMapList(v).map(ReactionDto.fromJson).toList();
OceanDto _ocean(Object? v) =>
    OceanDto.fromJson(v is Map<String, dynamic> ? v : const {});
TriggerSensitivitiesDto _triggers(Object? v) =>
    TriggerSensitivitiesDto.fromJson(v is Map<String, dynamic> ? v : const {});
AgentDto _agent(Object? v) =>
    AgentDto.fromJson(v is Map<String, dynamic> ? v : const {});

@JsonSerializable()
class SimulationDto {
  @JsonKey(name: "simulation_id", fromJson: jsonString)
  String simulationId;
  @JsonKey(name: "overall_conversion_rate", fromJson: jsonDouble)
  double overallConversionRate;
  @JsonKey(name: "overall_dropout_rate", fromJson: jsonDouble)
  double overallDropoutRate;
  @JsonKey(name: "overall_delayed_rate", fromJson: jsonDouble)
  double overallDelayedRate;
  @JsonKey(name: "agent_journeys", fromJson: _journeys)
  List<AgentJourneyDto> agentJourneys;
  @JsonKey(name: "stage_insights", fromJson: _stages)
  List<StageInsightDto> stageInsights;
  @JsonKey(name: "top_insights", fromJson: jsonStringList)
  List<String> topInsights;
  @JsonKey(name: "readiness_score", fromJson: jsonInt)
  int readinessScore;

  SimulationDto({
    required this.simulationId,
    required this.overallConversionRate,
    required this.overallDropoutRate,
    required this.overallDelayedRate,
    required this.agentJourneys,
    required this.stageInsights,
    required this.topInsights,
    required this.readinessScore,
  });

  SimulationModel toDto() {
    return SimulationModel(
      simulationId: simulationId,
      overallConversionRate: overallConversionRate,
      overallDropoutRate: overallDropoutRate,
      overallDelayedRate: overallDelayedRate,
      agentJourneys: agentJourneys.map((e) => e.toDto()).toList(),
      stageInsights: stageInsights.map((e) => e.toDto()).toList(),
      topInsights: topInsights,
      readinessScore: readinessScore,
    );
  }

  factory SimulationDto.fromJson(Map<String, dynamic> json) =>
      _$SimulationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SimulationDtoToJson(this);
}

@JsonSerializable()
class AgentJourneyDto {
  @JsonKey(name: "agent", fromJson: _agent)
  AgentDto agent;
  @JsonKey(name: "reactions", fromJson: _reactions)
  List<ReactionDto> reactions;
  @JsonKey(name: "final_outcome", fromJson: jsonString)
  String finalOutcome;
  @JsonKey(name: "dropped_at_stage", fromJson: jsonStringOrNull)
  String? droppedAtStage;

  AgentJourneyDto({
    required this.agent,
    required this.reactions,
    required this.finalOutcome,
    required this.droppedAtStage,
  });

  AgentJourney toDto() {
    return AgentJourney(
      agent: agent.toDto(),
      reactions: reactions.map((e) => e.toDto()).toList(),
      finalOutcome: finalOutcome,
      droppedAtStage: droppedAtStage,
    );
  }

  factory AgentJourneyDto.fromJson(Map<String, dynamic> json) =>
      _$AgentJourneyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AgentJourneyDtoToJson(this);
}

@JsonSerializable()
class AgentDto {
  @JsonKey(name: "id", fromJson: jsonString)
  String id;
  @JsonKey(name: "name", fromJson: jsonString)
  String name;
  @JsonKey(name: "age", fromJson: jsonInt)
  int age;
  @JsonKey(name: "gender", fromJson: jsonString)
  String gender;
  @JsonKey(name: "location", fromJson: jsonString)
  String location;
  @JsonKey(name: "income_bracket", fromJson: jsonString)
  String incomeBracket;
  @JsonKey(name: "decision_style", fromJson: jsonString)
  String decisionStyle;
  @JsonKey(name: "friction_threshold", fromJson: jsonInt)
  int frictionThreshold;
  @JsonKey(name: "backstory", fromJson: jsonString)
  String backstory;
  @JsonKey(name: "ocean", fromJson: _ocean)
  OceanDto ocean;
  @JsonKey(name: "status_quo_tendency", fromJson: jsonDouble)
  double statusQuoTendency;
  @JsonKey(name: "trigger_sensitivities", fromJson: _triggers)
  TriggerSensitivitiesDto triggerSensitivities;
  @JsonKey(name: "lifestyle_notes", fromJson: jsonString)
  String lifestyleNotes;

  AgentDto({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.incomeBracket,
    required this.decisionStyle,
    required this.frictionThreshold,
    required this.backstory,
    required this.ocean,
    required this.statusQuoTendency,
    required this.triggerSensitivities,
    required this.lifestyleNotes,
  });

  Agent toDto() {
    return Agent(
      id: id,
      name: name,
      age: age,
      gender: gender,
      location: location,
      incomeBracket: incomeBracket,
      decisionStyle: decisionStyle,
      frictionThreshold: frictionThreshold,
      backstory: backstory,
      ocean: ocean.toDto(),
      statusQuoTendency: statusQuoTendency,
      triggerSensitivities: triggerSensitivities.toDto(),
      lifestyleNotes: lifestyleNotes,
    );
  }

  factory AgentDto.fromJson(Map<String, dynamic> json) =>
      _$AgentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AgentDtoToJson(this);
}

@JsonSerializable()
class OceanDto {
  @JsonKey(name: "openness", fromJson: jsonDouble)
  double openness;
  @JsonKey(name: "conscientiousness", fromJson: jsonDouble)
  double conscientiousness;
  @JsonKey(name: "extraversion", fromJson: jsonDouble)
  double extraversion;
  @JsonKey(name: "agreeableness", fromJson: jsonDouble)
  double agreeableness;
  @JsonKey(name: "neuroticism", fromJson: jsonDouble)
  double neuroticism;

  OceanDto({
    required this.openness,
    required this.conscientiousness,
    required this.extraversion,
    required this.agreeableness,
    required this.neuroticism,
  });

  Ocean toDto() {
    return Ocean(
      openness: openness,
      conscientiousness: conscientiousness,
      extraversion: extraversion,
      agreeableness: agreeableness,
      neuroticism: neuroticism,
    );
  }

  factory OceanDto.fromJson(Map<String, dynamic> json) =>
      _$OceanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OceanDtoToJson(this);
}

@JsonSerializable()
class TriggerSensitivitiesDto {
  @JsonKey(name: "unexpected_cost", fromJson: jsonDouble)
  double unexpectedCost;
  @JsonKey(name: "trust_violation", fromJson: jsonDouble)
  double trustViolation;
  @JsonKey(name: "cognitive_load", fromJson: jsonDouble)
  double cognitiveLoad;
  @JsonKey(name: "effort_cost", fromJson: jsonDouble)
  double effortCost;
  @JsonKey(name: "value_mismatch", fromJson: jsonDouble)
  double valueMismatch;
  @JsonKey(name: "status_quo_inertia", fromJson: jsonDouble)
  double statusQuoInertia;

  TriggerSensitivitiesDto({
    required this.unexpectedCost,
    required this.trustViolation,
    required this.cognitiveLoad,
    required this.effortCost,
    required this.valueMismatch,
    required this.statusQuoInertia,
  });

  TriggerSensitivities toDto() {
    return TriggerSensitivities(
      unexpectedCost: unexpectedCost,
      trustViolation: trustViolation,
      cognitiveLoad: cognitiveLoad,
      effortCost: effortCost,
      valueMismatch: valueMismatch,
      statusQuoInertia: statusQuoInertia,
    );
  }

  factory TriggerSensitivitiesDto.fromJson(Map<String, dynamic> json) =>
      _$TriggerSensitivitiesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TriggerSensitivitiesDtoToJson(this);
}

@JsonSerializable()
class ReactionDto {
  @JsonKey(name: "stage_order", fromJson: jsonInt)
  int stageOrder;
  @JsonKey(name: "stage_name", fromJson: jsonString)
  String stageName;
  @JsonKey(name: "behaviour", fromJson: jsonString)
  String behaviour;
  @JsonKey(name: "internal_monologue", fromJson: jsonString)
  String internalMonologue;
  @JsonKey(name: "friction_triggered", fromJson: jsonStringOrNull)
  String? frictionTriggered;
  @JsonKey(name: "friction_cost", fromJson: jsonInt)
  int frictionCost;
  @JsonKey(name: "remaining_threshold", fromJson: jsonInt)
  int remainingThreshold;
  @JsonKey(name: "what_would_change_this", fromJson: jsonStringOrNull)
  String? whatWouldChangeThis;

  ReactionDto({
    required this.stageOrder,
    required this.stageName,
    required this.behaviour,
    required this.internalMonologue,
    required this.frictionTriggered,
    required this.frictionCost,
    required this.remainingThreshold,
    required this.whatWouldChangeThis,
  });

  Reaction toDto() {
    return Reaction(
      stageOrder: stageOrder,
      stageName: stageName,
      behaviour: behaviour,
      internalMonologue: internalMonologue,
      frictionTriggered: frictionTriggered,
      frictionCost: frictionCost,
      remainingThreshold: remainingThreshold,
      whatWouldChangeThis: whatWouldChangeThis,
    );
  }

  factory ReactionDto.fromJson(Map<String, dynamic> json) =>
      _$ReactionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionDtoToJson(this);
}

@JsonSerializable()
class StageInsightDto {
  @JsonKey(name: "stage_name", fromJson: jsonString)
  String stageName;
  @JsonKey(name: "dropout_rate", fromJson: jsonDouble)
  double dropoutRate;
  @JsonKey(name: "delay_rate", fromJson: jsonDouble)
  double delayRate;
  @JsonKey(name: "top_friction_trigger", fromJson: jsonStringOrNull)
  String? topFrictionTrigger;
  @JsonKey(name: "confusion_rate", fromJson: jsonInt)
  int confusionRate;

  StageInsightDto({
    required this.stageName,
    required this.dropoutRate,
    required this.delayRate,
    required this.topFrictionTrigger,
    required this.confusionRate,
  });

  StageInsight toDto() {
    return StageInsight(
      stageName: stageName,
      dropoutRate: dropoutRate,
      delayRate: delayRate,
      topFrictionTrigger: topFrictionTrigger,
      confusionRate: confusionRate,
    );
  }

  factory StageInsightDto.fromJson(Map<String, dynamic> json) =>
      _$StageInsightDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StageInsightDtoToJson(this);
}
