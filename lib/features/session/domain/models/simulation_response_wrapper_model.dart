import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';

class SimulationResponseWrapperModel {
  final SimulationModel result;
  final String experimentId;
  final String runKind;
  final int rerunsRemaining;
  final List<JourneyStageModel> journeyStages;

  SimulationResponseWrapperModel({
    required this.result,
    required this.experimentId,
    required this.runKind,
    required this.rerunsRemaining,
    required this.journeyStages,
  });
}
