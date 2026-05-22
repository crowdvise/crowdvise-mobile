// To parse this JSON data, do
//
//     final simulationDto = simulationDtoFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'simulation_dto.g.dart';

SimulationDto simulationDtoFromJson(String str) => SimulationDto.fromJson(json.decode(str));

String simulationDtoToJson(SimulationDto data) => json.encode(data.toJson());

@JsonSerializable()
class SimulationDto {
    @JsonKey(name: "simulation_id")
    String simulationId;
    @JsonKey(name: "overall_conversion_rate")
    int overallConversionRate;
    @JsonKey(name: "overall_dropout_rate")
    int overallDropoutRate;
    @JsonKey(name: "overall_delayed_rate")
    int overallDelayedRate;
    @JsonKey(name: "agent_journeys")
    List<AgentJourneyDto> agentJourneys;
    @JsonKey(name: "stage_insights")
    List<StageInsightDto> stageInsights;
    @JsonKey(name: "top_insights")
    List<String> topInsights;
    @JsonKey(name: "readiness_score")
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

    factory SimulationDto.fromJson(Map<String, dynamic> json) => _$SimulationDtoFromJson(json);

    Map<String, dynamic> toJson() => _$SimulationDtoToJson(this);
}

@JsonSerializable()
class AgentJourneyDto {
    @JsonKey(name: "agent")
    AgentDto agent;
    @JsonKey(name: "reactions")
    List<ReactionDto> reactions;
    @JsonKey(name: "final_outcome")
    String finalOutcome;
    @JsonKey(name: "dropped_at_stage")
    String droppedAtStage;

    AgentJourneyDto({
        required this.agent,
        required this.reactions,
        required this.finalOutcome,
        required this.droppedAtStage,
    });

    factory AgentJourneyDto.fromJson(Map<String, dynamic> json) => _$AgentJourneyDtoFromJson(json);

    Map<String, dynamic> toJson() => _$AgentJourneyDtoToJson(this);
}

@JsonSerializable()
class AgentDto {
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "age")
    int age;
    @JsonKey(name: "gender")
    String gender;
    @JsonKey(name: "location")
    String location;
    @JsonKey(name: "income_bracket")
    String incomeBracket;
    @JsonKey(name: "decision_style")
    String decisionStyle;
    @JsonKey(name: "friction_threshold")
    int frictionThreshold;
    @JsonKey(name: "backstory")
    String backstory;
    @JsonKey(name: "ocean")
    OceanDto ocean;
    @JsonKey(name: "status_quo_tendency")
    int statusQuoTendency;
    @JsonKey(name: "context_attributes")
    ContextAttributesDto contextAttributes;
    @JsonKey(name: "trigger_sensitivities")
    TriggerSensitivitiesDto triggerSensitivities;
    @JsonKey(name: "lifestyle_notes")
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
        required this.contextAttributes,
        required this.triggerSensitivities,
        required this.lifestyleNotes,
    });

    factory AgentDto.fromJson(Map<String, dynamic> json) => _$AgentDtoFromJson(json);

    Map<String, dynamic> toJson() => _$AgentDtoToJson(this);
}

@JsonSerializable()
class ContextAttributesDto {
    @JsonKey(name: "additionalProp1")
    String additionalProp1;
    @JsonKey(name: "additionalProp2")
    String additionalProp2;
    @JsonKey(name: "additionalProp3")
    String additionalProp3;

    ContextAttributesDto({
        required this.additionalProp1,
        required this.additionalProp2,
        required this.additionalProp3,
    });

    factory ContextAttributesDto.fromJson(Map<String, dynamic> json) => _$ContextAttributesDtoFromJson(json);

    Map<String, dynamic> toJson() => _$ContextAttributesDtoToJson(this);
}

@JsonSerializable()
class OceanDto {
    @JsonKey(name: "openness")
    int openness;
    @JsonKey(name: "conscientiousness")
    int conscientiousness;
    @JsonKey(name: "extraversion")
    int extraversion;
    @JsonKey(name: "agreeableness")
    int agreeableness;
    @JsonKey(name: "neuroticism")
    int neuroticism;

    OceanDto({
        required this.openness,
        required this.conscientiousness,
        required this.extraversion,
        required this.agreeableness,
        required this.neuroticism,
    });

    factory OceanDto.fromJson(Map<String, dynamic> json) => _$OceanDtoFromJson(json);

    Map<String, dynamic> toJson() => _$OceanDtoToJson(this);
}

@JsonSerializable()
class TriggerSensitivitiesDto {
    @JsonKey(name: "additionalProp1")
    int additionalProp1;
    @JsonKey(name: "additionalProp2")
    int additionalProp2;
    @JsonKey(name: "additionalProp3")
    int additionalProp3;

    TriggerSensitivitiesDto({
        required this.additionalProp1,
        required this.additionalProp2,
        required this.additionalProp3,
    });

    factory TriggerSensitivitiesDto.fromJson(Map<String, dynamic> json) => _$TriggerSensitivitiesDtoFromJson(json);

    Map<String, dynamic> toJson() => _$TriggerSensitivitiesDtoToJson(this);
}

@JsonSerializable()
class ReactionDto {
    @JsonKey(name: "stage_order")
    int stageOrder;
    @JsonKey(name: "stage_name")
    String stageName;
    @JsonKey(name: "behaviour")
    String behaviour;
    @JsonKey(name: "internal_monologue")
    String internalMonologue;
    @JsonKey(name: "friction_triggered")
    String frictionTriggered;
    @JsonKey(name: "friction_cost")
    int frictionCost;
    @JsonKey(name: "remaining_threshold")
    int remainingThreshold;
    @JsonKey(name: "what_would_change_this")
    String whatWouldChangeThis;

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

    factory ReactionDto.fromJson(Map<String, dynamic> json) => _$ReactionDtoFromJson(json);

    Map<String, dynamic> toJson() => _$ReactionDtoToJson(this);
}

@JsonSerializable()
class StageInsightDto {
    @JsonKey(name: "stage_name")
    String stageName;
    @JsonKey(name: "dropout_rate")
    int dropoutRate;
    @JsonKey(name: "delay_rate")
    int delayRate;
    @JsonKey(name: "top_friction_trigger")
    String topFrictionTrigger;
    @JsonKey(name: "confusion_rate")
    int confusionRate;

    StageInsightDto({
        required this.stageName,
        required this.dropoutRate,
        required this.delayRate,
        required this.topFrictionTrigger,
        required this.confusionRate,
    });

    factory StageInsightDto.fromJson(Map<String, dynamic> json) => _$StageInsightDtoFromJson(json);

    Map<String, dynamic> toJson() => _$StageInsightDtoToJson(this);
}
