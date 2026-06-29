import 'package:json_annotation/json_annotation.dart';
import 'package:ai_sports_training/src/features/settings/domain/entities/app_settings.dart';

part 'app_settings_model.g.dart';

@JsonSerializable()
class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    super.isDarkMode,
    super.language,
    super.notificationsEnabled,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  Map<String, dynamic> toFirestore() => _$AppSettingsModelToJson(this);
}