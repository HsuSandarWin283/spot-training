import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;

  const AppSettings({
    this.isDarkMode = false,
    this.language = 'en',
    this.notificationsEnabled = true,
  });

  @override
  List<Object?> get props => [isDarkMode, language, notificationsEnabled];

  AppSettings copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}