import 'package:cloud_firestore/cloud_firestore.dart';

class SportDetailItem {
  final String id;
  final String sportId;
  final String title;
  final String description;
  final DateTime createdAt;

  SportDetailItem({
    required this.id,
    required this.sportId,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory SportDetailItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SportDetailItem(
      id: doc.id,
      sportId: data['sportId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sportId': sportId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SportDetailItem copyWith({
    String? id,
    String? sportId,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return SportDetailItem(
      id: id ?? this.id,
      sportId: sportId ?? this.sportId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum SportDetailType {
  rules,
  trainingMethods,
  injuryPreventions,
  fitnessRequirements,
}

extension SportDetailTypeExtension on SportDetailType {
  String get collectionName {
    switch (this) {
      case SportDetailType.rules:
        return 'sport_rules';
      case SportDetailType.trainingMethods:
        return 'training_methods';
      case SportDetailType.injuryPreventions:
        return 'injury_preventions';
      case SportDetailType.fitnessRequirements:
        return 'fitness_requirements';
    }
  }

  String get label {
    switch (this) {
      case SportDetailType.rules:
        return 'Rules';
      case SportDetailType.trainingMethods:
        return 'Training Methods';
      case SportDetailType.injuryPreventions:
        return 'Injury Prevention';
      case SportDetailType.fitnessRequirements:
        return 'Fitness Requirements';
    }
  }

  String get singularLabel {
    switch (this) {
      case SportDetailType.rules:
        return 'Rule';
      case SportDetailType.trainingMethods:
        return 'Training Method';
      case SportDetailType.injuryPreventions:
        return 'Injury Prevention';
      case SportDetailType.fitnessRequirements:
        return 'Fitness Requirement';
    }
  }
}
