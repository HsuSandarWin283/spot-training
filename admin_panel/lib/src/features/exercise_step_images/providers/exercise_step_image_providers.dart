import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/models/exercise_step_image_model.dart';
import 'package:admin_panel/src/core/services/exercise_step_image_service.dart';

final exerciseStepImageServiceProvider =
    Provider<ExerciseStepImageService>((ref) {
  return ExerciseStepImageService();
});

final exerciseStepImagePostsProvider =
    StreamProvider<List<ExerciseStepImagePost>>((ref) {
  return ref.watch(exerciseStepImageServiceProvider).getPosts();
});

final exerciseStepImageItemsProvider =
    StreamProvider.family<List<ExerciseStepImageItem>, String>((ref, postId) {
  return ref.watch(exerciseStepImageServiceProvider).getItems(postId);
});

final exerciseStepImageTypesProvider =
    FutureProvider<List<String>>((ref) async {
  final service = ref.watch(exerciseStepImageServiceProvider);
  return service.getAllTypes();
});

final selectedExerciseStepImagePostProvider =
    StateProvider<ExerciseStepImagePost?>((ref) => null);
