import 'package:ai_sports_training/src/features/settings/data/datasources/settings_data_source.dart';
import 'package:ai_sports_training/src/features/settings/data/models/app_settings_model.dart';
import 'package:ai_sports_training/src/features/settings/domain/entities/app_settings.dart';
import 'package:ai_sports_training/src/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl(this.dataSource);

  @override
  Future<AppSettings> getSettings(String userId) {
    return dataSource.getSettings(userId);
  }

  @override
  Future<void> saveSettings(String userId, AppSettings settings) {
    return dataSource.saveSettings(userId, settings as AppSettingsModel);
  }
}