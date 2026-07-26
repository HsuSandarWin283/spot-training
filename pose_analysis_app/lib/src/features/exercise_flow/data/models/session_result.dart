import 'package:cloud_firestore/cloud_firestore.dart';

class StepResult {
  final int stepNumber;
  final double accuracy;
  final Map<String, double> angleDifferences;
  final Duration duration;
  final int attemptCount;

  StepResult({
    required this.stepNumber,
    required this.accuracy,
    required this.angleDifferences,
    required this.duration,
    this.attemptCount = 1,
  });

  Map<String, dynamic> toMap() => {
    'stepNumber': stepNumber,
    'accuracy': accuracy,
    'angleDifferences': angleDifferences,
    'durationSeconds': duration.inSeconds,
    'attemptCount': attemptCount,
  };
}

class ExerciseSessionResult {
  final String userId;
  final String exerciseId;
  final String exerciseName;
  final String categoryId;
  final List<StepResult> stepResults;
  final double overallAccuracy;
  final Duration totalDuration;
  final int estimatedCalories;
  final DateTime completedAt;

  ExerciseSessionResult({
    required this.userId,
    required this.exerciseId,
    required this.exerciseName,
    required this.categoryId,
    required this.stepResults,
    required this.overallAccuracy,
    required this.totalDuration,
    required this.estimatedCalories,
    required this.completedAt,
  });

  double get averageScore =>
      stepResults.isEmpty
          ? 0
          : stepResults.fold<double>(0, (sum, r) => sum + r.accuracy) /
              stepResults.length;

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'exerciseId': exerciseId,
    'exerciseName': exerciseName,
    'categoryId': categoryId,
    'stepResults': stepResults.map((r) => r.toMap()).toList(),
    'overallAccuracy': overallAccuracy,
    'totalDurationSeconds': totalDuration.inSeconds,
    'estimatedCalories': estimatedCalories,
    'completedAt': Timestamp.fromDate(completedAt),
  };
}
