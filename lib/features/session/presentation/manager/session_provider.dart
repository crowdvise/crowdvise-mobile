import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/validation/validation.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/core/presentation/utils/util_functions.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/domain/models/panel_size.dart';
import 'package:crowdvise/features/session/domain/repository/session_repository.dart';
import 'package:crowdvise/features/session/domain/usecase/generate_journey_usecase.dart';
import 'package:crowdvise/features/session/domain/usecase/run_simulation_usecase.dart';
import 'package:crowdvise/features/session/presentation/manager/session_state.dart';
import 'package:flutter/material.dart';

class SessionProvider extends CustomProvider {
  var state = SessionState();
  final _repo = getIt.get<SessionRepository>();

  void selectPanelSize(PanelSize panelSize) {
    state.selectedPanelSize = panelSize;
    notifyListeners();
  }

  void reset() {
    state = SessionState();
    notifyListeners();
  }

  void setProductDescription(String desc) {
    state.productDescription = desc;
    state.productDescriptionError = desc.validateField();
    _validateInfo();
  }

  void setTestScenario(String scenario) {
    state.testScenario = scenario;
    state.testScenarioError = scenario.validateField();
    _validateInfo();
  }

  void setTargetSegment(String segment) {
    state.targetSegment = segment;
    state.targetSegmentError = segment.validateField();
    _validateInfo();
  }

  void setJourneyName(String name) {
    state.journeyName = name;
    state.journeyNameError = name.validateField();
    _validateInfo();
  }

  void setJourneyDescription(String description) {
    state.journeyDescription = description;
    state.journeyDescriptionError = description.validateField();
    _validateInfo();
  }

  void _validateInfo() {
    state.isValidated = [
      state.productDescription.validateField() == null,
      state.testScenario.validateField() == null,
      state.targetSegment.validateField() == null,
    ].validate();
    notifyListeners();
  }

  void generateJourney() {
    onLoad();

    final result = GenerateJourneyUsecase(
      _repo,
      state.toJourneyPayload(),
    ).invoke();
    result.then((value) {
      final result = value.getOrElse((error) {
        add(error);
        return null;
      });

      if (result != null) {
        add(result);
        state.journeyStages = result.journeyStages;
        logg('Number of stages: ${state.journeyStages.length}');
      }
      onLoad();
    });
  }

  Future<void> runSimulation({required List<JourneyStageModel> stages}) async {
    try {
      onLoad();

      final value = await RunSimulationUsecase(
        _repo,
        state.toSimulationPayload(
          state.productDescription,
          state.targetSegment,
          stages,
        ),
      ).invoke();

      final result = value.getOrElse((error) {
        add(error);
        return null;
      });

      if (result != null) {
        add(result);
        state.simulationModel = result;
      }
    } catch (e, stack) {
      debugPrint('runSimulation error: $e');
      debugPrintStack(stackTrace: stack);
      add(e);
    } finally {
      onLoad();
    }
  }

  // void runSimulation({required List<JourneyStageModel> stages}) {
  //   onLoad();

  //   final result = RunSimulationUsecase(
  //     _repo,
  //     state.toSimulationPayload(
  //       state.productDescription,
  //       state.targetSegment,
  //       stages,
  //     ),
  //   ).invoke();
  //   result.then((value) {
  //     final result = value.getOrElse((error) {
  //       add(error);
  //       return null;
  //     });

  //     if (result != null) {
  //       add(result);
  //       state.simulationModel = result;
  //     }
  //     onLoad();
  //   });
  // }

  void updateStage(int order) {
    for (var item in state.journeyStages) {
      if (item.order == order) {
        item.name = state.journeyName;
        item.description = state.journeyDescription;
      }
    }
    notifyListeners();
  }

  void addStage() {
    state.journeyStages.add(
      JourneyStageModel(
        order: state.journeyStages.length + 1,
        name: state.journeyName,
        description: state.journeyDescription,
      ),
    );
    notifyListeners();
  }

  void deleteStage(int order) {
    int index = state.journeyStages.indexWhere((item) => item.order == order);
    if (index != -1) {
      state.journeyStages.removeAt(index);
    }
    notifyListeners();
  }
}
