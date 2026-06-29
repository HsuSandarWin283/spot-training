import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/settings/data/datasources/settings_data_source.dart';
import 'package:ai_sports_training/src/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:ai_sports_training/src/features/settings/domain/repositories/settings_repository.dart';

final settingsDataSourceProvider = Provider<SettingsDataSource>((ref) {
  return FirestoreSettingsDataSource();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.read(settingsDataSourceProvider));
});