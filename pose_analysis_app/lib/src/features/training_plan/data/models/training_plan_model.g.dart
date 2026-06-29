part of 'training_plan_model.dart';

TrainingPlanModel _$TrainingPlanModelFromJson(Map<String, dynamic> json) => TrainingPlanModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      sportId: json['sportId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      durationWeeks: json['durationWeeks'] as int,
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) => TrainingSessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TrainingPlanModelToJson(TrainingPlanModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'sportId': instance.sportId,
      'name': instance.name,
      'description': instance.description,
      'durationWeeks': instance.durationWeeks,
      'sessions': instance.sessions.map((e) => _$TrainingSessionModelToJson(e as TrainingSessionModel)).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

TrainingSessionModel _$TrainingSessionModelFromJson(Map<String, dynamic> json) => TrainingSessionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dayNumber: json['dayNumber'] as int,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingSessionModelToJson(TrainingSessionModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dayNumber': instance.dayNumber,
      'exercises': instance.exercises.map((e) => _$ExerciseModelToJson(e as ExerciseModel)).toList(),
    };

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) => ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      guidance: json['guidance'] as String?,
    );

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sets': instance.sets,
      'reps': instance.reps,
      'guidance': instance.guidance,
    };