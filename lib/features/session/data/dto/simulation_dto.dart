// To parse this JSON data, do
//
//     final simulationDto = simulationDtoFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'simulation_dto.g.dart';

SimulationDto simulationDtoFromJson(String str) =>
    SimulationDto.fromJson(json.decode(str));

String simulationDtoToJson(SimulationDto data) => json.encode(data.toJson());

@JsonSerializable()
class SimulationDto {
  @JsonKey(name: "simulation_id")
  String simulationId;
  @JsonKey(name: "overall_conversion_rate")
  double overallConversionRate;
  @JsonKey(name: "overall_dropout_rate")
  double overallDropoutRate;
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
  @JsonKey(name: "agent")
  AgentDto agent;
  @JsonKey(name: "reactions")
  List<ReactionDto> reactions;
  @JsonKey(name: "final_outcome")
  String finalOutcome;
  @JsonKey(name: "dropped_at_stage")
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
  double statusQuoTendency;
  // @JsonKey(name: "context_attributes")
  // ContextAttributesDto contextAttributes;
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
    // required this.contextAttributes,
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
      // contextAttributes: contextAttributes.toDto(),
      triggerSensitivities: triggerSensitivities.toDto(),
      lifestyleNotes: lifestyleNotes,
    );
  }

  factory AgentDto.fromJson(Map<String, dynamic> json) =>
      _$AgentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AgentDtoToJson(this);
}

// @JsonSerializable()
// class ContextAttributesDto {
//   @JsonKey(name: "cooking_confidence")
//   AuthenticityImportanceDto cookingConfidence;
//   @JsonKey(name: "spice_tolerance")
//   AuthenticityImportanceDto spiceTolerance;
//   @JsonKey(name: "time_availability")
//   AuthenticityImportanceDto timeAvailability;
//   @JsonKey(name: "authenticity_importance")
//   AuthenticityImportanceDto authenticityImportance;

//   ContextAttributesDto({
//     required this.cookingConfidence,
//     required this.spiceTolerance,
//     required this.timeAvailability,
//     required this.authenticityImportance,
//   });

//   ContextAttributes toDto() {
//     return ContextAttributes(
//       cookingConfidence: cookingConfidence.toDto(),
//       spiceTolerance: spiceTolerance.toDto(),
//       timeAvailability: timeAvailability.toDto(),
//       authenticityImportance: authenticityImportance.toDto(),
//     );
//   }

//   factory ContextAttributesDto.fromJson(Map<String, dynamic> json) =>
//       _$ContextAttributesDtoFromJson(json);

//   Map<String, dynamic> toJson() => _$ContextAttributesDtoToJson(this);
// }

// enum AuthenticityImportanceDto {
//   @JsonValue("high")
//   HIGH,
//   @JsonValue("low")
//   LOW,
//   @JsonValue("moderate")
//   MODERATE,
// }

// extension on AuthenticityImportanceDto {
//   AuthenticityImportance toDto() {
//     switch (this) {
//       case AuthenticityImportanceDto.HIGH:
//         return AuthenticityImportance.HIGH;
//       case AuthenticityImportanceDto.LOW:
//         return AuthenticityImportance.LOW;
//       case AuthenticityImportanceDto.MODERATE:
//         return AuthenticityImportance.MODERATE;
//     }
//   }
// }

// final authenticityImportanceValues = EnumValues({
//   "high": AuthenticityImportanceDto.HIGH,
//   "low": AuthenticityImportanceDto.LOW,
//   "moderate": AuthenticityImportanceDto.MODERATE,
// });

// enum DecisionStyleDto {
//   @JsonValue("analytical")
//   ANALYTICAL,
//   @JsonValue("deliberate")
//   DELIBERATE,
//   @JsonValue("impulsive")
//   IMPULSIVE,
// }

// extension on DecisionStyleDto {
//   DecisionStyle toDto() {
//     switch (this) {
//       case DecisionStyleDto.ANALYTICAL:
//         return DecisionStyle.ANALYTICAL;
//       case DecisionStyleDto.DELIBERATE:
//         return DecisionStyle.DELIBERATE;
//       case DecisionStyleDto.IMPULSIVE:
//         return DecisionStyle.IMPULSIVE;
//     }
//   }
// }

// final decisionStyleValues = EnumValues({
//   "analytical": DecisionStyleDto.ANALYTICAL,
//   "deliberate": DecisionStyleDto.DELIBERATE,
//   "impulsive": DecisionStyleDto.IMPULSIVE,
// });

// enum GenderDto {
//   @JsonValue("female")
//   FEMALE,
//   @JsonValue("male")
//   MALE,
//   @JsonValue("non-binary")
//   NON_BINARY,
// }

// extension on GenderDto {
//   Gender toDto() {
//     switch (this) {
//       case GenderDto.FEMALE:
//         return Gender.FEMALE;
//       case GenderDto.MALE:
//         return Gender.MALE;
//       case GenderDto.NON_BINARY:
//         return Gender.NON_BINARY;
//       }
//   }
// }

// final genderValues = EnumValues({
//   "female": GenderDto.FEMALE,
//   "male": GenderDto.MALE,
//   "non-binary": GenderDto.NON_BINARY,
// });

// enum IncomeBracketDto {
//   @JsonValue("high")
//   HIGH,
//   @JsonValue("low")
//   LOW,
//   @JsonValue("middle")
//   MIDDLE,
// }

// extension on IncomeBracketDto {
//   IncomeBracket toDto() {
//     switch (this) {
//       case IncomeBracketDto.HIGH:
//         return IncomeBracket.HIGH;
//       case IncomeBracketDto.LOW:
//         return IncomeBracket.LOW;
//       case IncomeBracketDto.MIDDLE:
//         return IncomeBracket.MIDDLE;
//     }
//   }
// }

// final incomeBracketValues = EnumValues({
//   "high": IncomeBracketDto.HIGH,
//   "low": IncomeBracketDto.LOW,
//   "middle": IncomeBracketDto.MIDDLE,
// });

@JsonSerializable()
class OceanDto {
  @JsonKey(name: "openness")
  double openness;
  @JsonKey(name: "conscientiousness")
  double conscientiousness;
  @JsonKey(name: "extraversion")
  double extraversion;
  @JsonKey(name: "agreeableness")
  double agreeableness;
  @JsonKey(name: "neuroticism")
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
  @JsonKey(name: "unexpected_cost")
  double unexpectedCost;
  @JsonKey(name: "trust_violation")
  double trustViolation;
  @JsonKey(name: "cognitive_load")
  double cognitiveLoad;
  @JsonKey(name: "effort_cost")
  double effortCost;
  @JsonKey(name: "value_mismatch")
  double valueMismatch;
  @JsonKey(name: "status_quo_inertia")
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

// enum FinalOutcomeDto {
//   @JsonValue("continuing")
//   CONTINUING,
//   @JsonValue("converted")
//   CONVERTED,
//   @JsonValue("delaying")
//   DELAYING,
//   @JsonValue("dropped")
//   DROPPED,
//   @JsonValue("frustrated")
//   FRUSTRATED,
// }

// extension on FinalOutcomeDto {
//   FinalOutcome toDto() {
//     switch (this) {
//       case FinalOutcomeDto.CONTINUING:
//         return FinalOutcome.CONTINUING;
//       case FinalOutcomeDto.CONVERTED:
//         return FinalOutcome.CONVERTED;
//       case FinalOutcomeDto.DELAYING:
//         return FinalOutcome.DELAYING;
//       case FinalOutcomeDto.DROPPED:
//         return FinalOutcome.DROPPED;
//       case FinalOutcomeDto.FRUSTRATED:
//         return FinalOutcome.FRUSTRATED;
//     }
//   }
// }

// final finalOutcomeValues = EnumValues({
//   "continuing": FinalOutcomeDto.CONTINUING,
//   "converted": FinalOutcomeDto.CONVERTED,
//   "delaying": FinalOutcomeDto.DELAYING,
//   "dropped": FinalOutcomeDto.DROPPED,
//   "frustrated": FinalOutcomeDto.FRUSTRATED,
// });

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
  String? frictionTriggered;
  @JsonKey(name: "friction_cost")
  int frictionCost;
  @JsonKey(name: "remaining_threshold")
  int remainingThreshold;
  @JsonKey(name: "what_would_change_this")
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

// enum TopFrictionTriggerDto {
//   @JsonValue("cognitive_load")
//   COGNITIVE_LOAD,
//   @JsonValue("status_quo_inertia")
//   STATUS_QUO_INERTIA,
//   @JsonValue("unexpected_cost")
//   UNEXPECTED_COST,
//   @JsonValue("value_mismatch")
//   VALUE_MISMATCH,
// }

// extension on TopFrictionTriggerDto {
//   TopFrictionTrigger toDto() {
//     switch (this) {
//       case TopFrictionTriggerDto.COGNITIVE_LOAD:
//         return TopFrictionTrigger.COGNITIVE_LOAD;
//       case TopFrictionTriggerDto.STATUS_QUO_INERTIA:
//         return TopFrictionTrigger.STATUS_QUO_INERTIA;
//       case TopFrictionTriggerDto.UNEXPECTED_COST:
//         return TopFrictionTrigger.UNEXPECTED_COST;
//       case TopFrictionTriggerDto.VALUE_MISMATCH:
//         return TopFrictionTrigger.VALUE_MISMATCH;
//     }
//   }
// }

// final topFrictionTriggerValues = EnumValues({
//   "cognitive_load": TopFrictionTriggerDto.COGNITIVE_LOAD,
//   "status_quo_inertia": TopFrictionTriggerDto.STATUS_QUO_INERTIA,
//   "unexpected_cost": TopFrictionTriggerDto.UNEXPECTED_COST,
//   "value_mismatch": TopFrictionTriggerDto.VALUE_MISMATCH,
// });

@JsonSerializable()
class StageInsightDto {
  @JsonKey(name: "stage_name")
  String stageName;
  @JsonKey(name: "dropout_rate")
  double dropoutRate;
  @JsonKey(name: "delay_rate")
  double delayRate;
  @JsonKey(name: "top_friction_trigger")
  String? topFrictionTrigger;
  @JsonKey(name: "confusion_rate")
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
