import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';

class SimulationPayload {
    String productDescription;
    String targetSegment;
    int panelSize;
    List<JourneyStageModel> journeyStages;

    SimulationPayload({
        required this.productDescription,
        required this.targetSegment,
        required this.panelSize,
        required this.journeyStages,
    });

}
