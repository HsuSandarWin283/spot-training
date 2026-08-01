import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/exercise_progress/data/services/exercise_progress_service.dart';
import 'package:ai_sports_training/src/features/exercise_progress/data/models/goal_progress.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

final exerciseProgressServiceProvider = Provider<ExerciseProgressService>(
    (ref) => ExerciseProgressService());

final goalProgressListProvider = FutureProvider<List<GoalProgress>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final service = ref.read(exerciseProgressServiceProvider);
  return service.getGoalProgressList(user.uid);
});

final exerciseRecommendationsProvider =
    FutureProvider<List<ExerciseProgressEntry>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final service = ref.read(exerciseProgressServiceProvider);
  return service.getRecommendations(user.uid);
});

final feedbackMapProvider = FutureProvider<Map<String, String>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};
  final service = ref.read(exerciseProgressServiceProvider);
  return service.getFeedbackMap(user.uid);
});
