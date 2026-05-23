import 'package:crowdvise/features/session/domain/models/generate_journey_payload.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/domain/models/panel_size.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_payload.dart';

class SessionState {
  bool isValidated = false;
  String productDescription = "";
  String? productDescriptionError;
  String testScenario = "";
  String? testScenarioError;
  String targetSegment = "";
  String? targetSegmentError;
  String journeyName = "";
  String? journeyNameError;
  String journeyDescription = "";
  String? journeyDescriptionError;
  GeneratedJourneyModel? generatedJourneyModel;
  SimulationModel? simulationModel;

  PanelSize? selectedPanelSize;
  final List<PanelSize> panelSize = [
    PanelSize(value: '10', title: 'Quick', estimatedTime: '~2 min'),
    PanelSize(value: '25', title: 'Standard', estimatedTime: '~3 min'),
    PanelSize(value: '50', title: 'Deep', estimatedTime: '~10 min'),
  ];

  List<JourneyStageModel> journeyStages = [];

  GenerateJourneyPayload toJourneyPayload() {
    return GenerateJourneyPayload(
      productDescription: productDescription,
      testScenario: testScenario,
      targetSegment: targetSegment,
    );
  }

  SimulationPayload toSimulationPayload(
    String prodDesc,
    String tSegment,
    List<JourneyStageModel> jStages,
  ) {
    return SimulationPayload(
      targetSegment: tSegment,
      panelSize: int.parse(selectedPanelSize!.value),
      productDescription: prodDesc,
      journeyStages: journeyStages,
    );
  }
}
