class CloudinaryConfig {
  static const String cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'rq4qrlcq',
  );

  static const String uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'sport-training',
  );

  static const String apiKey = String.fromEnvironment(
    'CLOUDINARY_API_KEY',
    defaultValue: '472954165138697',
  );

  static const String apiSecret = String.fromEnvironment(
    'CLOUDINARY_API_SECRET',
    defaultValue: 'gb0VSlxIPfUq1EhF8YmMqNkDGmQ',
  );

  static bool get isSigned => apiKey.isNotEmpty && apiSecret.isNotEmpty;

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  static String get destroyUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';
}
