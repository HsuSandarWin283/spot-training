import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female, other }

enum FitnessLevel { beginner, intermediate, advanced }

class FitnessAssessment {
  final String id;
  final String userId;
  final int age;
  final Gender gender;
  final double heightCm;
  final double weightKg;
  final int exerciseFrequency;
  final int activityLevel;
  final double overallScore;
  final FitnessLevel fitnessLevel;
  final bool isCompleted;
  final DateTime createdAt;

  const FitnessAssessment({
    required this.id,
    required this.userId,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.exerciseFrequency,
    required this.activityLevel,
    required this.overallScore,
    required this.fitnessLevel,
    this.isCompleted = false,
    required this.createdAt,
  });

  factory FitnessAssessment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FitnessAssessment(
      id: doc.id,
      userId: data['userId'] ?? '',
      age: data['age'] ?? 0,
      gender: Gender.values.firstWhere(
        (g) => g.toString().split('.').last == data['gender'],
        orElse: () => Gender.other,
      ),
      heightCm: (data['heightCm'] ?? 0).toDouble(),
      weightKg: (data['weightKg'] ?? 0).toDouble(),
      exerciseFrequency: data['exerciseFrequency'] ?? 0,
      activityLevel: data['activityLevel'] ?? 0,
      overallScore: (data['overallScore'] ?? 0).toDouble(),
      fitnessLevel: FitnessLevel.values.firstWhere(
        (l) => l.toString().split('.').last == data['fitnessLevel'],
        orElse: () => FitnessLevel.beginner,
      ),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'age': age,
      'gender': gender.toString().split('.').last,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'exerciseFrequency': exerciseFrequency,
      'activityLevel': activityLevel,
      'overallScore': overallScore,
      'fitnessLevel': fitnessLevel.toString().split('.').last,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
