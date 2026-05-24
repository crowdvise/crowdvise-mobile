// ignore_for_file: constant_identifier_names

class SimulationModel {
    String simulationId;
    double overallConversionRate;
    double overallDropoutRate;
    double overallDelayedRate;
    List<AgentJourney> agentJourneys;
    List<StageInsight> stageInsights;
    List<String> topInsights;
    int readinessScore;

    SimulationModel({
        required this.simulationId,
        required this.overallConversionRate,
        required this.overallDropoutRate,
        required this.overallDelayedRate,
        required this.agentJourneys,
        required this.stageInsights,
        required this.topInsights,
        required this.readinessScore,
    });

}

class AgentJourney {
    Agent agent;
    List<Reaction> reactions;
    String finalOutcome;
    String? droppedAtStage;

    AgentJourney({
        required this.agent,
        required this.reactions,
        required this.finalOutcome,
        required this.droppedAtStage,
    });

}

class Agent {
    String id;
    String name;
    int age;
    String gender;
    String location;
    String incomeBracket;
    String decisionStyle;
    int frictionThreshold;
    String backstory;
    Ocean ocean;
    double statusQuoTendency;
    // ContextAttributes contextAttributes;
    TriggerSensitivities triggerSensitivities;
    String lifestyleNotes;

    Agent({
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

}

class ContextAttributes {
    String cookingConfidence;
    String spiceTolerance;
    String timeAvailability;
    String authenticityImportance;

    ContextAttributes({
        required this.cookingConfidence,
        required this.spiceTolerance,
        required this.timeAvailability,
        required this.authenticityImportance,
    });

}

// enum AuthenticityImportance {
//     HIGH,
//     LOW,
//     MODERATE
// }

// enum DecisionStyle {
//     ANALYTICAL,
//     DELIBERATE,
//     IMPULSIVE
// }

// enum Gender {
//     FEMALE,
//     MALE,
//     NON_BINARY,
// }

// enum IncomeBracket {
//     HIGH,
//     LOW,
//     MIDDLE
// }

class Ocean {
    double openness;
    double conscientiousness;
    double extraversion;
    double agreeableness;
    double neuroticism;

    Ocean({
        required this.openness,
        required this.conscientiousness,
        required this.extraversion,
        required this.agreeableness,
        required this.neuroticism,
    });

}

class TriggerSensitivities {
    double unexpectedCost;
    double trustViolation;
    double cognitiveLoad;
    double effortCost;
    double valueMismatch;
    double statusQuoInertia;

    TriggerSensitivities({
        required this.unexpectedCost,
        required this.trustViolation,
        required this.cognitiveLoad,
        required this.effortCost,
        required this.valueMismatch,
        required this.statusQuoInertia,
    });

}

enum StageName {
    ABANDONMENT_AND_RETARGETING,
    DISCOUNT_DRIVEN_RETURN,
    INITIAL_PRODUCT_PAGE_VISIT,
    PRICE_SHOCK,
    SOCIAL_DISCOVERY,
    VALUE_JUSTIFICATION_SEARCH
}

enum FinalOutcome {
    CONTINUING,
    CONVERTED,
    DELAYING,
    DROPPED,
    FRUSTRATED
}

class Reaction {
    int stageOrder;
    String stageName;
    String behaviour;
    String internalMonologue;
    String? frictionTriggered;
    int frictionCost;
    int remainingThreshold;
    String? whatWouldChangeThis;

    Reaction({
        required this.stageOrder,
        required this.stageName,
        required this.behaviour,
        required this.internalMonologue,
        required this.frictionTriggered,
        required this.frictionCost,
        required this.remainingThreshold,
        required this.whatWouldChangeThis,
    });

}


class StageInsight {
    String stageName;
    double dropoutRate;
    double delayRate;
    String? topFrictionTrigger;
    int confusionRate;

    StageInsight({
        required this.stageName,
        required this.dropoutRate,
        required this.delayRate,
        required this.topFrictionTrigger,
        required this.confusionRate,
    });

}
