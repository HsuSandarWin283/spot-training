import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/training_plan/data/datasources/training_plan_data_source.dart';
import 'package:ai_sports_training/src/features/training_plan/data/repositories/training_plan_repository_impl.dart';
import 'package:ai_sports_training/src/features/training_plan/domain/repositories/training_plan_repository.dart';

final trainingPlanDataSourceProvider = Provider<TrainingPlanDataSource>((ref) {
  return FirestoreTrainingPlanDataSource();
});

final trainingPlanRepositoryProvider = Provider<TrainingPlanRepository>((ref) {
  return TrainingPlanRepositoryImpl(ref.read(trainingPlanDataSourceProvider));
});