import 'package:equatable/equatable.dart';

class TrainingPlan extends Equatable {
  final String id;
  final String userId;
  final String sportId;
  final String name;
  final String description;
  final int durationWeeks;
  final List<TrainingSession> sessions;
  final DateTime createdAt;

  const TrainingPlan({
    required this.id,
    required this.userId,
    required this.sportId,
    required this.name,
    required this.description,
    required this.durationWeeks,
    required this.sessions,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        sportId,
        name,
        description,
        durationWeeks,
        sessions,
        createdAt
      ];
}

class TrainingSession extends Equatable {
  final String id;
  final String name;
  final int dayNumber;
  final List<Exercise> exercises;

  const TrainingSession({
    required this.id,
    required this.name,
    required this.dayNumber,
    required this.exercises,
  });

  @override
  List<Object?> get props => [id, name, dayNumber, exercises];
}

class Exercise extends Equatable {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final String? guidance;

  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    this.guidance,
  });

  @override
  List<Object?> get props => [id, name, sets, reps, guidance];
}