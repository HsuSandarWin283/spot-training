import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/data/services/exercise_completion_service.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

final exerciseCompletionServiceProvider =
    Provider<ExerciseCompletionService>((ref) => ExerciseCompletionService());

final completionsByTypeProvider =
    StreamProvider<List<TypeCompletionCount>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  final service = ref.read(exerciseCompletionServiceProvider);
  return service.watchCompletionsByType(user.uid);
});
