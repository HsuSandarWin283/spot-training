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

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'titleEn': titleEn,
      'titleMm': titleMm,
      'descriptionEn': descriptionEn,
      'descriptionMm': descriptionMm,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  InjuryItem copyWith({
    String? id,
    String? type,
    String? titleEn,
    String? titleMm,
    String? descriptionEn,
    String? descriptionMm,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return InjuryItem(
      id: id ?? this.id,
      type: type ?? this.type,
      titleEn: titleEn ?? this.titleEn,
      titleMm: titleMm ?? this.titleMm,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionMm: descriptionMm ?? this.descriptionMm,
      imageUrl: imageUrl ?? this.imageUrl,
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

  String get singularLabel {
    switch (this) {
      case InjuryDataType.prevention:
        return 'Prevention Tip';
      case InjuryDataType.treatment:
        return 'Treatment Tip';
    }
  }
}
