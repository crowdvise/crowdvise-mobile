import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/features/history/domain/repository/history_repository.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/domain/models/simulation_response_wrapper_model.dart';
import 'package:crowdvise/features/session/domain/repository/session_repository.dart';

/// One instance is shared across Fix List → Preview → Loading → Results so
/// `rerunsRemaining` is a single source of truth for the whole experiment.
class ExperimentProvider extends CustomProvider {
  final _repo = getIt.get<SessionRepository>();
  final _history = getIt.get<HistoryRepository>();

  List<FixSuggestion>? fixes;
  int? rerunsRemaining;
  PreviewFixResponse? previewResult;
  SimulationResponseWrapperModel? testFixResult;
  CompareExperimentResponse? compareResult;

  /// Which fix is currently being previewed (per-card spinner).
  String? previewingFixId;

  /// Last user-facing error, so loading screens can show it inline instead of
  /// relying on a stream that may be owned by another route.
  String? lastError;

  /// Full results per run id, fetched for stage-by-stage compare bars.
  final Map<String, SimulationModel> runDetails = {};
  bool loadingDetails = false;

  bool get canRerun => (rerunsRemaining ?? 0) > 0;

  void setInitialRerunsRemaining(int count) {
    rerunsRemaining = count;
  }

  Future<void> fetchFixes(String experimentId) async {
    if (loading) return;
    setLoading(true);
    lastError = null;
    try {
      final result = await _repo.suggestFixes(experimentId: experimentId);
      final data = result.getOrElse((error) {
        lastError = error.toString();
        add(error);
        return null;
      });

      if (data != null) {
        fixes = data.fixes;
        rerunsRemaining = data.rerunsRemaining;
      }
    } catch (e) {
      lastError = 'Could not load suggested fixes. Please try again.';
      add(lastError!);
    } finally {
      setLoading(false);
    }
  }

  Future<PreviewFixResponse?> previewFix(String experimentId, String fixId) async {
    if (previewingFixId != null) return null;
    previewingFixId = fixId;
    lastError = null;
    notifyListeners();
    try {
      final result = await _repo.previewFix(experimentId: experimentId, fixId: fixId);
      final data = result.getOrElse((error) {
        lastError = error.toString();
        add(error);
        return null;
      });
      if (data != null) previewResult = data;
      return data;
    } catch (e) {
      lastError = 'Could not preview this fix. Please try again.';
      add(lastError!);
      return null;
    } finally {
      previewingFixId = null;
      notifyListeners();
    }
  }

  Future<SimulationResponseWrapperModel?> testFix(
    String experimentId,
    String fixId,
  ) async {
    if (!canRerun) {
      lastError = 'No re-runs left on this experiment. Start a new simulation.';
      add(lastError!);
      return null;
    }
    if (loading) return null;
    setLoading(true);
    lastError = null;
    try {
      final result = await _repo.testFix(experimentId: experimentId, fixId: fixId);
      final data = result.getOrElse((error) {
        lastError = error.toString();
        add(error);
        return null;
      });

      if (data != null) {
        testFixResult = data;
        rerunsRemaining = data.rerunsRemaining;
      }
      return data;
    } catch (e) {
      lastError = 'The re-run didn’t complete. Nothing was charged against your re-runs.';
      add(lastError!);
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> getCompareData(String experimentId) async {
    if (loading) return;
    setLoading(true);
    lastError = null;
    try {
      final result = await _repo.getExperimentRuns(experimentId: experimentId);
      final data = result.getOrElse((error) {
        lastError = error.toString();
        add(error);
        return null;
      });

      if (data != null) {
        compareResult = data;
        rerunsRemaining = data.rerunsRemaining;
      }
      if (data != null) await _loadRunDetails(data.runs);
    } catch (e) {
      lastError = 'Could not load run comparison. Please try again.';
      add(lastError!);
    } finally {
      setLoading(false);
    }
  }

  Future<void> _loadRunDetails(List<ExperimentRun> runs) async {
    final missing = runs.where((r) => !runDetails.containsKey(r.runId)).toList();
    if (missing.isEmpty) return;
    loadingDetails = true;
    notifyListeners();
    await Future.wait(missing.map((r) async {
      final res = await _history.getPastSimulation(simulationId: r.runId);
      final sim = res.getOrElse((_) => null);
      if (sim != null) runDetails[r.runId] = sim;
    }));
    loadingDetails = false;
    notifyListeners();
  }
}
