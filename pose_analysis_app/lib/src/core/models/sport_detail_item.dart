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
    final titleEn = (data['titleEn'] as String?)?.trim() ?? '';
    final titleMm = (data['titleMm'] as String?)?.trim() ?? '';
    final descriptionEn = (data['descriptionEn'] as String?)?.trim() ?? '';
    final descriptionMm = (data['descriptionMm'] as String?)?.trim() ?? '';
    final fallbackTitle = (data['title'] as String?)?.trim() ?? '';
    final fallbackDesc = (data['description'] as String?)?.trim() ?? '';
    return SportDetailItem(
      id: doc.id,
      sportId: data['sportId'] ?? '',
      titleEn: titleEn.isNotEmpty ? titleEn : fallbackTitle,
      titleMm: titleMm.isNotEmpty ? titleMm : fallbackTitle,
      descriptionEn: descriptionEn.isNotEmpty ? descriptionEn : fallbackDesc,
      descriptionMm: descriptionMm.isNotEmpty ? descriptionMm : fallbackDesc,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  String get title => titleEn;
  String get description => descriptionEn;

  String localizedTitle(String languageCode) {
    if (languageCode == 'my') return titleMm.isNotEmpty ? titleMm : titleEn;
    return titleEn.isNotEmpty ? titleEn : titleMm;
  }

  String localizedDescription(String languageCode) {
    if (languageCode == 'my') return descriptionMm.isNotEmpty ? descriptionMm : descriptionEn;
    return descriptionEn.isNotEmpty ? descriptionEn : descriptionMm;
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

  String get label => labelEn;

  String labelFor(String languageCode) {
    if (languageCode == 'my') return labelMm;
    return labelEn;
  }
}
