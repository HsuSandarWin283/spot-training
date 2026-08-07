import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseStepImageItem {
  final String id;
  final String imageUrl;
  final String descriptionEn;
  final String descriptionMm;
  final int stepOrder;
  final int stepNumber;
  final Map<String, List<double>> poseLandmarks;
  final Map<String, double> poseAngles;

  ExerciseStepImageItem({
    required this.id,
    required this.imageUrl,
    required this.descriptionEn,
    required this.descriptionMm,
    required this.stepOrder,
    this.stepNumber = 1,
    this.poseLandmarks = const {},
    this.poseAngles = const {},
  });

  factory ExerciseStepImageItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final rawLandmarks = Map<String, dynamic>.from(data['poseLandmarks'] ?? {});
    final landmarks = <String, List<double>>{};
    for (final entry in rawLandmarks.entries) {
      if (entry.value is List) {
        landmarks[entry.key] =
            (entry.value as List).map((e) => (e as num).toDouble()).toList();
      }
    }

    final rawAngles = Map<String, dynamic>.from(data['poseAngles'] ?? {});
    final angles = <String, double>{};
    for (final entry in rawAngles.entries) {
      if (entry.value is num) {
        angles[entry.key] = (entry.value as num).toDouble();
      }
    }

    final descriptionEn = data['descriptionEn'] ?? data['description'] ?? '';
    final descriptionMm = data['descriptionMm'] ?? data['description'] ?? '';
    return ExerciseStepImageItem(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      descriptionEn: descriptionEn,
      descriptionMm: descriptionMm,
      stepOrder: data['stepOrder'] ?? 0,
      stepNumber: data['stepNumber'] ?? 1,
      poseLandmarks: landmarks,
      poseAngles: angles,
    );
  }

  String localizedDescription(String languageCode) {
    if (languageCode == 'my') return descriptionMm.isNotEmpty ? descriptionMm : descriptionEn;
    return descriptionEn.isNotEmpty ? descriptionEn : descriptionMm;
  }

  String get description => descriptionEn;
}

class ExerciseStepImagePost {
  final String id;
  final String titleEn;
  final String titleMm;
  final String type;
  final String sportId;
  final int itemCount;
  final DateTime createdAt;

  ExerciseStepImagePost({
    required this.id,
    required this.titleEn,
    required this.titleMm,
    required this.type,
    required this.sportId,
    required this.itemCount,
    required this.createdAt,
  });

  factory ExerciseStepImagePost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final titleEn = data['titleEn'] ?? data['title'] ?? '';
    final titleMm = data['titleMm'] ?? data['title'] ?? '';
    return ExerciseStepImagePost(
      id: doc.id,
      titleEn: titleEn,
      titleMm: titleMm,
      type: data['type'] ?? '',
      sportId: data['sportId'] ?? '',
      itemCount: data['itemCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  String localizedTitle(String languageCode) {
    if (languageCode == 'my') return titleMm.isNotEmpty ? titleMm : titleEn;
    return titleEn.isNotEmpty ? titleEn : titleMm;
  }

  String get title => titleEn;
}
