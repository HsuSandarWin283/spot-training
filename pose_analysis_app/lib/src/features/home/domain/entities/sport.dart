import 'package:equatable/equatable.dart';

class Sport extends Equatable {
  final String id;
  final String nameEn;
  final String nameMm;
  final String descriptionEn;
  final String descriptionMm;
  final String imageUrl;

  const Sport({
    required this.id,
    required this.nameEn,
    required this.nameMm,
    required this.descriptionEn,
    required this.descriptionMm,
    required this.imageUrl,
  });

  String localizedName(String languageCode) {
    if (languageCode == 'my') return nameMm.isNotEmpty ? nameMm : nameEn;
    return nameEn.isNotEmpty ? nameEn : nameMm;
  }

  String localizedDescription(String languageCode) {
    if (languageCode == 'my') return descriptionMm.isNotEmpty ? descriptionMm : descriptionEn;
    return descriptionEn.isNotEmpty ? descriptionEn : descriptionMm;
  }

  String get name => nameEn;
  String get description => descriptionEn;

  @override
  List<Object?> get props => [id, nameEn, nameMm, descriptionEn, descriptionMm, imageUrl];
}