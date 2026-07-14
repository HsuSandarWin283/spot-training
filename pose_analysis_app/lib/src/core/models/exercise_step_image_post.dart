import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseStepImageItem {
  final String id;
  final String imageUrl;
  final String description;
  final int stepOrder;

  ExerciseStepImageItem({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.stepOrder,
  });

  factory ExerciseStepImageItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseStepImageItem(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      stepOrder: data['stepOrder'] ?? 0,
    );
  }
}

class ExerciseStepImagePost {
  final String id;
  final String title;
  final String type;
  final String sportId;
  final int itemCount;
  final DateTime createdAt;

  ExerciseStepImagePost({
    required this.id,
    required this.title,
    required this.type,
    required this.sportId,
    required this.itemCount,
    required this.createdAt,
  });

  factory ExerciseStepImagePost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseStepImagePost(
      id: doc.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      sportId: data['sportId'] ?? '',
      itemCount: data['itemCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
