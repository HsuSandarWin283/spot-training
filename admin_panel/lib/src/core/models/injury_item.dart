import 'package:cloud_firestore/cloud_firestore.dart';

class InjuryItem {
  final String id;
  final String type;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  InjuryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.createdAt,
  });

  factory InjuryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InjuryItem(
      id: doc.id,
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  InjuryItem copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return InjuryItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
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

  String get singularLabel {
    switch (this) {
      case InjuryDataType.prevention:
        return 'Prevention Tip';
      case InjuryDataType.treatment:
        return 'Treatment Tip';
    }
  }
}
