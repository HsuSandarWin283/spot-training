import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/services/cloud_tts_service.dart';

final cloudTtsServiceProvider = Provider<CloudTtsService>((ref) {
  final service = CloudTtsService();
  ref.onDispose(() => service.dispose());
  return service;
});
