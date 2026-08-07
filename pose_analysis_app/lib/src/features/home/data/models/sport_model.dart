import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ai_sports_training/src/features/home/domain/entities/sport.dart';

part 'sport_model.g.dart';

@JsonSerializable()
class SportModel extends Sport {
  const SportModel({
    required super.id,
    required super.nameEn,
    required super.nameMm,
    required super.descriptionEn,
    required super.descriptionMm,
    required super.imageUrl,
  });

  factory SportModel.fromJson(Map<String, dynamic> json) => _$SportModelFromJson(json);
  factory SportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final nameEn = data['nameEn'] ?? data['name'] ?? '';
    final nameMm = data['nameMm'] ?? data['name'] ?? '';
    final descriptionEn = data['descriptionEn'] ?? data['description'] ?? '';
    final descriptionMm = data['descriptionMm'] ?? data['description'] ?? '';
    return SportModel(
      id: doc.id,
      nameEn: nameEn,
      nameMm: nameMm,
      descriptionEn: descriptionEn,
      descriptionMm: descriptionMm,
      imageUrl: data['imageUrl'] ?? '',
    );
  }
  Map<String, dynamic> toFirestore() => _$SportModelToJson(this);
}