import 'package:ai_sports_training/src/features/training_plan/data/datasources/training_plan_data_source.dart';
import 'package:ai_sports_training/src/features/training_plan/data/models/training_plan_model.dart';
import 'package:ai_sports_training/src/features/training_plan/domain/entities/training_plan.dart';
import 'package:ai_sports_training/src/features/training_plan/domain/repositories/training_plan_repository.dart';

class TrainingPlanRepositoryImpl implements TrainingPlanRepository {
  final TrainingPlanDataSource dataSource;

  TrainingPlanRepositoryImpl(this.dataSource);

  @override
  Future<List<TrainingPlan>> getUserTrainingPlans(String userId) {
    return dataSource.getUserTrainingPlans(userId);
  }

  @override
  Future<TrainingPlan?> getTrainingPlan(String planId) {
    return dataSource.getTrainingPlan(planId);
  }

  @override
  Future<void> createTrainingPlan(TrainingPlan plan) {
    return dataSource.createTrainingPlan(plan as TrainingPlanModel);
  }

  @override
  Future<void> updateTrainingPlan(TrainingPlan plan) {
    return dataSource.updateTrainingPlan(plan as TrainingPlanModel);
  }

  @override
  Future<void> deleteTrainingPlan(String planId) {
    return dataSource.deleteTrainingPlan(planId);
  }
}