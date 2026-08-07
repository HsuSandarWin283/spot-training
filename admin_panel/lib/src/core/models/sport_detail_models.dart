import 'package:cloud_firestore/cloud_firestore.dart';

class SportDetailItem {
  final String id;
  final String sportId;
  final String titleEn;
  final String titleMm;
  final String descriptionEn;
  final String descriptionMm;
  final DateTime createdAt;

  SportDetailItem({
    required this.id,
    required this.sportId,
    required this.titleEn,
    required this.titleMm,
    required this.descriptionEn,
    required this.descriptionMm,
    required this.createdAt,
  });

  factory SportDetailItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final titleEn = data['titleEn'] ?? data['title'] ?? '';
    final titleMm = data['titleMm'] ?? data['title'] ?? '';
    final descriptionEn = data['descriptionEn'] ?? data['description'] ?? '';
    final descriptionMm = data['descriptionMm'] ?? data['description'] ?? '';
    return SportDetailItem(
      id: doc.id,
      sportId: data['sportId'] ?? '',
      titleEn: titleEn,
      titleMm: titleMm,
      descriptionEn: descriptionEn,
      descriptionMm: descriptionMm,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sportId': sportId,
      'titleEn': titleEn,
      'titleMm': titleMm,
      'descriptionEn': descriptionEn,
      'descriptionMm': descriptionMm,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SportDetailItem copyWith({
    String? id,
    String? sportId,
    String? titleEn,
    String? titleMm,
    String? descriptionEn,
    String? descriptionMm,
    DateTime? createdAt,
  }) {
    return SportDetailItem(
      id: id ?? this.id,
      sportId: sportId ?? this.sportId,
      titleEn: titleEn ?? this.titleEn,
      titleMm: titleMm ?? this.titleMm,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionMm: descriptionMm ?? this.descriptionMm,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String localizedTitle(String languageCode) {
    if (languageCode == 'my') return titleMm.isNotEmpty ? titleMm : titleEn;
    return titleEn.isNotEmpty ? titleEn : titleMm;
  }

  String localizedDescription(String languageCode) {
    if (languageCode == 'my') return descriptionMm.isNotEmpty ? descriptionMm : descriptionEn;
    return descriptionEn.isNotEmpty ? descriptionEn : descriptionMm;
  }

  String get title => titleEn;
  String get description => descriptionEn;
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

  String get labelEn {
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

  String get labelMm {
    switch (this) {
      case SportDetailType.rules:
        return 'နည်းဥပဒေ';
      case SportDetailType.trainingMethods:
        return 'လေ့ကျင့်နည်းများ';
      case SportDetailType.injuryPreventions:
        return 'ဒဏ်ခံမှုဆိုင်ရာ';
      case SportDetailType.fitnessRequirements:
        return 'ကျန်းမာရေး အခန်းကဏ္ဍများ';
    }
  }

  String get singularLabelEn {
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

  String get singularLabelMm {
    switch (this) {
      case SportDetailType.rules:
        return 'နည်းဥပဒေ';
      case SportDetailType.trainingMethods:
        return 'လေ့ကျင့်နည်း';
      case SportDetailType.injuryPreventions:
        return 'ဒဏ်ခံမှုဆိုင်ရာ';
      case SportDetailType.fitnessRequirements:
        return 'ကျန်းမာရေး အခန်းကဏ္ဍ';
    }
  }

  String get label => '$labelEn / $labelMm';
  String get singularLabel => '$singularLabelEn / $singularLabelMm';
}
