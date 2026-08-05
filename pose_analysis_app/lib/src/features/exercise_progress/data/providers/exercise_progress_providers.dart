import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/exercise_progress/data/services/exercise_progress_service.dart';
import 'package:ai_sports_training/src/features/exercise_progress/data/models/goal_progress.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

final exerciseProgressServiceProvider = Provider<ExerciseProgressService>(
    (ref) => ExerciseProgressService());

final goalProgressListProvider =
    StreamProvider<List<GoalProgress>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  final service = ref.read(exerciseProgressServiceProvider);
  return service.watchGoalProgressList(user.uid);
});

final exerciseRecommendationsProvider =
    StreamProvider<List<ExerciseProgressEntry>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  final service = ref.read(exerciseProgressServiceProvider);
  return service.watchRecommendations(user.uid);
});

final feedbackMapProvider = StreamProvider<Map<String, String>>((ref) {
  return ref.watch(goalProgressListProvider.stream).map((goals) {
    final Map<String, String> feedback = {};
    for (final goal in goals) {
      feedback[goal.goal] = goal.feedback;
    }
    return feedback;
  });
});
