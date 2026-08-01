class PerformanceReport {
  final double overallProgressPercentage;
  final String fitnessLevel;
  final List<String> strengths;
  final List<String> areasToImprove;
  final List<String> recommendedExercises;
  final String summaryFeedback;
  final double? strengthImprovement;
  final double? flexibilityImprovement;
  final double? balanceImprovement;
  final double? coordinationImprovement;
  final double? overallImprovement;

  const PerformanceReport({
    required this.overallProgressPercentage,
    required this.fitnessLevel,
    required this.strengths,
    required this.areasToImprove,
    required this.recommendedExercises,
    required this.summaryFeedback,
    this.strengthImprovement,
    this.flexibilityImprovement,
    this.balanceImprovement,
    this.coordinationImprovement,
    this.overallImprovement,
  });
}
