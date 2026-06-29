import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ai_sports_training/src/features/home/domain/entities/sport.dart';

part 'sport_model.g.dart';

@JsonSerializable()
class SportModel extends Sport {
  const SportModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
  });

  factory SportModel.fromJson(Map<String, dynamic> json) => _$SportModelFromJson(json);
  factory SportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SportModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
  Map<String, dynamic> toFirestore() => _$SportModelToJson(this);
}