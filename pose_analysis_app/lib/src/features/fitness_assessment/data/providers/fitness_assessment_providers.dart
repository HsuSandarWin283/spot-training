import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/services/fitness_assessment_service.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/fitness_assessment.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/exercise_history.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/category_progress.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/performance_report.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

final fitnessAssessmentServiceProvider = Provider<FitnessAssessmentService>((ref) {
  return FitnessAssessmentService();
});

final hasCompletedAssessmentProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  final service = ref.read(fitnessAssessmentServiceProvider);
  return service.hasCompletedAssessment(user.uid);
});

final latestAssessmentProvider = FutureProvider<FitnessAssessment?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final service = ref.read(fitnessAssessmentServiceProvider);
  return service.getLatestAssessment(user.uid);
});

final exerciseHistoryProvider = FutureProvider<List<ExerciseHistory>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final service = ref.read(fitnessAssessmentServiceProvider);
  return service.getExerciseHistory(user.uid);
});

final categoryProgressProvider = FutureProvider<List<CategoryProgress>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final service = ref.read(fitnessAssessmentServiceProvider);
  return service.getCategoryProgress(user.uid);
});

final performanceReportProvider = FutureProvider<PerformanceReport>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const PerformanceReport(
      overallProgressPercentage: 0,
      fitnessLevel: 'beginner',
      strengths: [],
      areasToImprove: [],
      recommendedExercises: [],
      summaryFeedback: 'Start your fitness journey!',
    );
  }
  final service = ref.read(fitnessAssessmentServiceProvider);
  return service.generatePerformanceReport(user.uid);
});
