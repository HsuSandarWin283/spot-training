import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ai_sports_training/src/features/training_plan/domain/entities/training_plan.dart';

part 'training_plan_model.g.dart';

@JsonSerializable()
class TrainingPlanModel extends TrainingPlan {
  const TrainingPlanModel({
    required super.id,
    required super.userId,
    required super.sportId,
    required super.name,
    required super.description,
    required super.durationWeeks,
    required super.sessions,
    required super.createdAt,
  });

  factory TrainingPlanModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingPlanModelFromJson(json);

  factory TrainingPlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrainingPlanModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      sportId: data['sportId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      durationWeeks: data['durationWeeks'] ?? 4,
      sessions: (data['sessions'] as List<dynamic>?)
              ?.map((e) => TrainingSessionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => _$TrainingPlanModelToJson(this);
}

@JsonSerializable()
class TrainingSessionModel extends TrainingSession {
  const TrainingSessionModel({
    required super.id,
    required super.name,
    required super.dayNumber,
    required super.exercises,
  });

  factory TrainingSessionModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionModelFromJson(json);

  Map<String, dynamic> toFirestore() => _$TrainingSessionModelToJson(this);
}

@JsonSerializable()
class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.sets,
    required super.reps,
    super.guidance,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toFirestore() => _$ExerciseModelToJson(this);
}