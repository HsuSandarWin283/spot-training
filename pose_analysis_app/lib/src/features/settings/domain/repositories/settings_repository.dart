import 'package:ai_sports_training/src/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings(String userId);
  Future<void> saveSettings(String userId, AppSettings settings);
}