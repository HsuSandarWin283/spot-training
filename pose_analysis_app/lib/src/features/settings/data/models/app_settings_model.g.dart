part of 'app_settings_model.dart';

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) => AppSettingsModel(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) => <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'language': instance.language,
      'notificationsEnabled': instance.notificationsEnabled,
    };