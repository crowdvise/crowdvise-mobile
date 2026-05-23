class HistoryModel {
    List<RunModel> runs;

    HistoryModel({
        required this.runs,
    });

}

class RunModel {
    String id;
    String productDescription;
    String targetSegment;
    int panelSize;
    double overallConversionRate;
    double overallDropoutRate;
    double overallDelayedRate;
    int readinessScore;
    String createdAt;

    RunModel({
        required this.id,
        required this.productDescription,
        required this.targetSegment,
        required this.panelSize,
        required this.overallConversionRate,
        required this.overallDropoutRate,
        required this.overallDelayedRate,
        required this.readinessScore,
        required this.createdAt,
    });

}
