import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:ai_sports_training/src/features/settings/data/models/app_settings_model.dart';
import 'package:ai_sports_training/src/features/settings/domain/entities/app_settings.dart';
import 'package:ai_sports_training/src/features/settings/domain/repositories/settings_repository.dart';

class GetSettings implements UseCase<AppSettings, GetSettingsParams> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  Future<AppSettings> call(GetSettingsParams params) {
    return repository.getSettings(params.userId);
  }
}

class GetSettingsParams {
  final String userId;

  GetSettingsParams(this.userId);
}

class SaveSettings implements UseCase<void, SaveSettingsParams> {
  final SettingsRepository repository;

  SaveSettings(this.repository);

  @override
  Future<void> call(SaveSettingsParams params) {
    return repository.saveSettings(params.userId, params.settings as AppSettingsModel);
  }
}

class SaveSettingsParams {
  final String userId;
  final AppSettings settings;

  SaveSettingsParams(this.userId, this.settings);
}