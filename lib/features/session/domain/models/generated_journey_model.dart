class GeneratedJourneyModel {
    List<JourneyStageModel> journeyStages;

    GeneratedJourneyModel({
        required this.journeyStages,
    });

}

class JourneyStageModel {
    int order;
    String name;
    String description;

    JourneyStageModel({
        required this.order,
        required this.name,
        required this.description,
    });

}
