part of 'sport_model.dart';

SportModel _$SportModelFromJson(Map<String, dynamic> json) => SportModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String? ?? json['name'] as String? ?? '',
      nameMm: json['nameMm'] as String? ?? json['name'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? json['description'] as String? ?? '',
      descriptionMm: json['descriptionMm'] as String? ?? json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$SportModelToJson(SportModel instance) => <String, dynamic>{
      'id': instance.id,
      'nameEn': instance.nameEn,
      'nameMm': instance.nameMm,
      'descriptionEn': instance.descriptionEn,
      'descriptionMm': instance.descriptionMm,
      'imageUrl': instance.imageUrl,
    };