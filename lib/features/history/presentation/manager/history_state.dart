import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';

class HistoryState {
  int subcribed = 0;
  int dropped = 0;
  final List<RunModel> history = [];
  SimulationModel? histroyDetails;
}
