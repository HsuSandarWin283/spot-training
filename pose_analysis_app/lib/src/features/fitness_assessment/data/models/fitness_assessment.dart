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
  final double? balanceScore;
  final double? squatScore;
  final double? shoulderFlexibilityScore;
  final double? jumpScore;
  final double? strengthScore;
  final double? flexibilityScore;
  final double? balanceTotalScore;
  final double? coordinationScore;
  final double? overallScore;
  final FitnessLevel? fitnessLevel;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const FitnessAssessment({
    required this.id,
    required this.userId,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.balanceScore,
    this.squatScore,
    this.shoulderFlexibilityScore,
    this.jumpScore,
    this.strengthScore,
    this.flexibilityScore,
    this.balanceTotalScore,
    this.coordinationScore,
    this.overallScore,
    this.fitnessLevel,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  factory FitnessAssessment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FitnessAssessment(
      id: doc.id,
      userId: data['userId'] ?? '',
      age: data['age'] ?? 0,
      gender: Gender.values.firstWhere(
        (g) => g.name == data['gender'],
        orElse: () => Gender.other,
      ),
      heightCm: (data['heightCm'] ?? 0).toDouble(),
      weightKg: (data['weightKg'] ?? 0).toDouble(),
      balanceScore: data['balanceScore']?.toDouble(),
      squatScore: data['squatScore']?.toDouble(),
      shoulderFlexibilityScore: data['shoulderFlexibilityScore']?.toDouble(),
      jumpScore: data['jumpScore']?.toDouble(),
      strengthScore: data['strengthScore']?.toDouble(),
      flexibilityScore: data['flexibilityScore']?.toDouble(),
      balanceTotalScore: data['balanceTotalScore']?.toDouble(),
      coordinationScore: data['coordinationScore']?.toDouble(),
      overallScore: data['overallScore']?.toDouble(),
      fitnessLevel: data['fitnessLevel'] != null
          ? FitnessLevel.values.firstWhere(
              (l) => l.name == data['fitnessLevel'],
              orElse: () => FitnessLevel.beginner,
            )
          : null,
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'age': age,
      'gender': gender.name,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'balanceScore': balanceScore,
      'squatScore': squatScore,
      'shoulderFlexibilityScore': shoulderFlexibilityScore,
      'jumpScore': jumpScore,
      'strengthScore': strengthScore,
      'flexibilityScore': flexibilityScore,
      'balanceTotalScore': balanceTotalScore,
      'coordinationScore': coordinationScore,
      'overallScore': overallScore,
      'fitnessLevel': fitnessLevel?.name,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  FitnessAssessment copyWith({
    double? balanceScore,
    double? squatScore,
    double? shoulderFlexibilityScore,
    double? jumpScore,
    double? strengthScore,
    double? flexibilityScore,
    double? balanceTotalScore,
    double? coordinationScore,
    double? overallScore,
    FitnessLevel? fitnessLevel,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return FitnessAssessment(
      id: id,
      userId: userId,
      age: age,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
      balanceScore: balanceScore ?? this.balanceScore,
      squatScore: squatScore ?? this.squatScore,
      shoulderFlexibilityScore: shoulderFlexibilityScore ?? this.shoulderFlexibilityScore,
      jumpScore: jumpScore ?? this.jumpScore,
      strengthScore: strengthScore ?? this.strengthScore,
      flexibilityScore: flexibilityScore ?? this.flexibilityScore,
      balanceTotalScore: balanceTotalScore ?? this.balanceTotalScore,
      coordinationScore: coordinationScore ?? this.coordinationScore,
      overallScore: overallScore ?? this.overallScore,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
