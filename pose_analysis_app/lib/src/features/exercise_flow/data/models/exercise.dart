import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise_step.dart';

class Exercise {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String imageUrl;
  final List<ExerciseStep> steps;
  final DateTime createdAt;

  Exercise({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.steps = const [],
    required this.createdAt,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Exercise(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      steps: (data['steps'] as List<dynamic>?)
              ?.map((s) => ExerciseStep.fromMap(Map<String, dynamic>.from(s)))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'categoryId': categoryId,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'steps': steps.map((s) => s.toMap()).toList(),
    'createdAt': Timestamp.fromDate(createdAt),
  };

  int get stepCount => steps.length;
}
