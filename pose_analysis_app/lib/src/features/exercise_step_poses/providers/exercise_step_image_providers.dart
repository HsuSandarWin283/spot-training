import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/models/exercise_step_image_post.dart';
import 'package:ai_sports_training/src/core/services/exercise_step_image_service.dart';

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
