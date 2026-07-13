class CloudinaryConfig {
  static const String cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'YOUR_CLOUD_NAME',
  );

  static const String uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'YOUR_UPLOAD_PRESET',
  );

  static const String apiKey = String.fromEnvironment(
    'CLOUDINARY_API_KEY',
    defaultValue: '',
  );

  static const String apiSecret = String.fromEnvironment(
    'CLOUDINARY_API_SECRET',
    defaultValue: '',
  );

  static bool get isSigned => apiKey.isNotEmpty && apiSecret.isNotEmpty;

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  static String get destroyUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';
}
