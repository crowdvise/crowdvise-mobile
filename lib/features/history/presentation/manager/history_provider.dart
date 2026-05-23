import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/history/domain/repository/history_repository.dart';
import 'package:crowdvise/features/history/domain/usecases/get_history_usecase.dart';
import 'package:crowdvise/features/history/domain/usecases/get_past_simulation_usecase.dart';
import 'package:crowdvise/features/history/presentation/manager/history_state.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';

class HistoryProvider extends CustomProvider {
  final _repo = getIt.get<HistoryRepository>();
  final state = HistoryState();

  void fetchHistory() {
    onLoad();

    final result = GetHistoryUsecase(_repo).invoke();
    result.then((value) {
      final result = value.getOrElse((error) {
        add(error);
        return null;
      });

      if (result != null) {
        add(result);
        state.history.clear();
        state.history.addAll(result.runs);
      }
      onLoad();
    });
  }

  void gePastSimulations({required String simulationId}) {
    onLoad();

    final result = GetPastSimulationUsecase(_repo, simulationId).invoke();
    result.then((value) {
      final result = value.getOrElse((error) {
        add(error);
        return null;
      });

      if (result != null) {
        add(result);
        state.histroyDetails = result;
        for (var agentJourney in result.agentJourneys) {
          if (agentJourney.finalOutcome == "converted" &&
              agentJourney.droppedAtStage == null) {
            state.subcribed += 1;
          } else if (agentJourney.finalOutcome == "dropped" &&
              agentJourney.droppedAtStage != null) {
            state.dropped += 1;
          }
        }
      }
      onLoad();
    });
  }

  String getHeadlineInsight(SimulationModel simulation) {
    final score = simulation.readinessScore;

    if (score >= 80) {
      return simulation.topInsights.firstWhere(
        (i) => i.toLowerCase().contains('conversion'),
        orElse: () => simulation.topInsights.first,
      );
    }

    if (score >= 60) {
      return simulation.topInsights.firstWhere(
        (i) =>
            i.toLowerCase().contains('product-market fit') ||
            i.toLowerCase().contains('conversion'),
        orElse: () => simulation.topInsights.first,
      );
    }

    return simulation.topInsights.firstWhere(
      (i) =>
          i.toLowerCase().contains('dropout') ||
          i.toLowerCase().contains('friction'),
      orElse: () => simulation.topInsights.first,
    );
  }
}
