import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/history/domain/repository/history_repository.dart';
import 'package:crowdvise/features/history/domain/usecases/get_history_usecase.dart';
import 'package:crowdvise/features/history/domain/usecases/get_past_simulation_usecase.dart';
import 'package:crowdvise/features/history/presentation/manager/history_state.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';

class HistoryProvider extends CustomProvider {
  final _repo = getIt.get<HistoryRepository>();
  var state = HistoryState();
  String? lastError;

  void reset() {
    state = HistoryState();
    lastError = null;
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    if (loading) return;
    setLoading(true);
    lastError = null;
    try {
      final value = await GetHistoryUsecase(_repo).invoke();
      final result = value.getOrElse((error) {
        lastError = error.toString();
        add(error);
        return null;
      });

      if (result != null) {
        state.history
          ..clear()
          ..addAll(result.runs);
      }
    } catch (e) {
      lastError = 'Could not load your history. Please try again.';
      add(lastError!);
    } finally {
      setLoading(false);
    }
  }

  Future<void> gePastSimulations({required String simulationId}) async {
    if (loading) return;
    setLoading(true);
    lastError = null;
    try {
      final value = await GetPastSimulationUsecase(_repo, simulationId).invoke();
      final result = value.getOrElse((error) {
        lastError = error.toString();
        add(error);
        return null;
      });

      if (result != null) {
        state.histroyDetails = result;
        state.subcribed = 0;
        state.dropped = 0;
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
    } catch (e) {
      lastError = 'Could not load this run. Please try again.';
      add(lastError!);
    } finally {
      setLoading(false);
    }
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
