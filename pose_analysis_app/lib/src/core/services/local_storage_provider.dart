import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_sports_training/src/core/services/local_storage_service.dart';

final localStorageServiceProvider = FutureProvider<LocalStorageService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorageService(prefs);
});
