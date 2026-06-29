class AppConstants {
  static const String appName = 'AI Sports Training';
  static const String appVersion = '1.0.0';
  static const String defaultLanguage = 'en';
  static const int maxRetryAttempts = 3;
  static const Duration cacheTimeout = Duration(hours: 24);
  
  static const List<String> supportedSports = [
    'soccer',
    'basketball',
    'tennis',
    'swimming',
    'yoga',
    'weight_training',
  ];
}