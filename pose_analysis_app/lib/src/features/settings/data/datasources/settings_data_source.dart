import 'package:ai_sports_training/src/features/settings/data/models/app_settings_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SettingsDataSource {
  Future<AppSettingsModel> getSettings(String userId);
  Future<void> saveSettings(String userId, AppSettingsModel settings);
}

class FirestoreSettingsDataSource implements SettingsDataSource {
  final FirebaseFirestore firestore;

  FirestoreSettingsDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AppSettingsModel> getSettings(String userId) async {
    final doc = firestore.collection('settings').doc(userId);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      return const AppSettingsModel();
    }
    return AppSettingsModel.fromJson(snapshot.data()!);
  }

  @override
  Future<void> saveSettings(String userId, AppSettingsModel settings) {
    return firestore.collection('settings').doc(userId).set(settings.toFirestore());
  }
}