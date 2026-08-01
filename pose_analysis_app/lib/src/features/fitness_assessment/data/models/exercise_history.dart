import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseHistory {
  final String id;
  final String userId;
  final String exerciseId;
  final String exerciseName;
  final String categoryId;
  final String categoryName;
  final double accuracy;
  final int durationSeconds;
  final int estimatedCalories;
  final int stepCount;
  final DateTime completedAt;
  final double? improvementPercentage;

  const ExerciseHistory({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.exerciseName,
    required this.categoryId,
    required this.categoryName,
    required this.accuracy,
    required this.durationSeconds,
    required this.estimatedCalories,
    required this.stepCount,
    required this.completedAt,
    this.improvementPercentage,
  });

  factory ExerciseHistory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseHistory(
      id: doc.id,
      userId: data['userId'] ?? '',
      exerciseId: data['exerciseId'] ?? '',
      exerciseName: data['exerciseName'] ?? '',
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      accuracy: (data['accuracy'] ?? 0).toDouble(),
      durationSeconds: data['durationSeconds'] ?? 0,
      estimatedCalories: data['estimatedCalories'] ?? 0,
      stepCount: data['stepCount'] ?? 0,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      improvementPercentage: data['improvementPercentage']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'accuracy': accuracy,
      'durationSeconds': durationSeconds,
      'estimatedCalories': estimatedCalories,
      'stepCount': stepCount,
      'completedAt': Timestamp.fromDate(completedAt),
      'improvementPercentage': improvementPercentage,
    };
  }
}
