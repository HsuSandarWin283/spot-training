import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:ai_sports_training/src/features/training_plan/data/models/training_plan_model.dart';
import 'package:ai_sports_training/src/features/training_plan/domain/entities/training_plan.dart';
import 'package:ai_sports_training/src/features/training_plan/domain/repositories/training_plan_repository.dart';

class GetUserTrainingPlans
    implements UseCase<List<TrainingPlan>, GetUserTrainingPlansParams> {
  final TrainingPlanRepository repository;

  GetUserTrainingPlans(this.repository);

  @override
  Future<List<TrainingPlan>> call(GetUserTrainingPlansParams params) {
    return repository.getUserTrainingPlans(params.userId);
  }
}

class GetUserTrainingPlansParams {
  final String userId;

  GetUserTrainingPlansParams(this.userId);
}

class GetTrainingPlan
    implements UseCase<TrainingPlan?, GetTrainingPlanParams> {
  final TrainingPlanRepository repository;

  GetTrainingPlan(this.repository);

  @override
  Future<TrainingPlan?> call(GetTrainingPlanParams params) {
    return repository.getTrainingPlan(params.planId);
  }
}

class GetTrainingPlanParams {
  final String planId;

  GetTrainingPlanParams(this.planId);
}

class CreateTrainingPlan
    implements UseCase<void, CreateTrainingPlanParams> {
  final TrainingPlanRepository repository;

  CreateTrainingPlan(this.repository);

  @override
  Future<void> call(CreateTrainingPlanParams params) {
    return repository.createTrainingPlan(params.plan as TrainingPlanModel);
  }
}

class CreateTrainingPlanParams {
  final TrainingPlan plan;

  CreateTrainingPlanParams(this.plan);
}

class UpdateTrainingPlan
    implements UseCase<void, UpdateTrainingPlanParams> {
  final TrainingPlanRepository repository;

  UpdateTrainingPlan(this.repository);

  @override
  Future<void> call(UpdateTrainingPlanParams params) {
    return repository.updateTrainingPlan(params.plan as TrainingPlanModel);
  }
}

class UpdateTrainingPlanParams {
  final TrainingPlan plan;

  UpdateTrainingPlanParams(this.plan);
}

class DeleteTrainingPlan
    implements UseCase<void, DeleteTrainingPlanParams> {
  final TrainingPlanRepository repository;

  DeleteTrainingPlan(this.repository);

  @override
  Future<void> call(DeleteTrainingPlanParams params) {
    return repository.deleteTrainingPlan(params.planId);
  }
}

class DeleteTrainingPlanParams {
  final String planId;

  DeleteTrainingPlanParams(this.planId);
}