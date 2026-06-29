import 'package:ai_sports_training/src/features/training_plan/domain/entities/training_plan.dart';

abstract class TrainingPlanRepository {
  Future<List<TrainingPlan>> getUserTrainingPlans(String userId);
  Future<TrainingPlan?> getTrainingPlan(String planId);
  Future<void> createTrainingPlan(TrainingPlan plan);
  Future<void> updateTrainingPlan(TrainingPlan plan);
  Future<void> deleteTrainingPlan(String planId);
}