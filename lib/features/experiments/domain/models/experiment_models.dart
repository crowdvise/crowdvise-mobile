import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';

class SuggestFixesResponse {
  final List<FixSuggestion> fixes;
  final int rerunsRemaining;

  SuggestFixesResponse({required this.fixes, required this.rerunsRemaining});
}

class FixSuggestion {
  final String id;
  final String title;
  final String rationale;
  final String targetStageName;
  final String originalDescription;
  final String patchedDescription;
  final String expectedImpact;

  FixSuggestion({
    required this.id,
    required this.title,
    required this.rationale,
    required this.targetStageName,
    required this.originalDescription,
    required this.patchedDescription,
    required this.expectedImpact,
  });
}

class PreviewFixResponse {
  final FixSuggestion fix;
  final List<JourneyStageModel> journeyBefore;
  final List<JourneyStageModel> journeyAfter;

  PreviewFixResponse({
    required this.fix,
    required this.journeyBefore,
    required this.journeyAfter,
  });
}

class CompareExperimentResponse {
  final String experimentId;
  final List<ExperimentRun> runs;
  final int rerunsRemaining;

  CompareExperimentResponse({
    required this.experimentId,
    required this.runs,
    required this.rerunsRemaining,
  });
}

class ExperimentRun {
  final String runId;
  final String runKind;
  final int runIndex;
  final FixSuggestion? appliedFix;
  final double overallConversionRate;
  final double overallDropoutRate;
  final double overallDelayedRate;
  final int readinessScore;
  final String readinessLevel;

  ExperimentRun({
    required this.runId,
    required this.runKind,
    required this.runIndex,
    required this.appliedFix,
    required this.overallConversionRate,
    required this.overallDropoutRate,
    required this.overallDelayedRate,
    required this.readinessScore,
    required this.readinessLevel,
  });
}
