import 'package:cloud_firestore/cloud_firestore.dart';

class InjuryItem {
  final String id;
  final String type;
  final String titleEn;
  final String titleMm;
  final String descriptionEn;
  final String descriptionMm;
  final String imageUrl;
  final DateTime createdAt;

  InjuryItem({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleMm,
    required this.descriptionEn,
    required this.descriptionMm,
    this.imageUrl = '',
    required this.createdAt,
  });

  factory InjuryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final titleEn = data['titleEn'] ?? data['title'] ?? '';
    final titleMm = data['titleMm'] ?? data['title'] ?? '';
    final descriptionEn = data['descriptionEn'] ?? data['description'] ?? '';
    final descriptionMm = data['descriptionMm'] ?? data['description'] ?? '';
    return InjuryItem(
      id: doc.id,
      type: data['type'] ?? '',
      titleEn: titleEn,
      titleMm: titleMm,
      descriptionEn: descriptionEn,
      descriptionMm: descriptionMm,
      imageUrl: data['imageUrl'] ?? '',
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

enum InjuryDataType {
  prevention,
  treatment,
}

extension InjuryDataTypeExtension on InjuryDataType {
  String get label {
    switch (this) {
      case InjuryDataType.prevention:
        return 'Prevention';
      case InjuryDataType.treatment:
        return 'Treatment';
    }
  }
}
