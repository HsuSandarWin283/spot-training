import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseCategory {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final int exerciseCount;
  final DateTime createdAt;

  ExerciseCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.exerciseCount = 0,
    required this.createdAt,
  });

  factory ExerciseCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseCategory(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      iconName: data['iconName'] ?? 'fitness_center',
      exerciseCount: data['exerciseCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'iconName': iconName,
    'exerciseCount': exerciseCount,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
