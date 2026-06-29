import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/profile/data/models/user_profile_model.dart';

abstract class ProfileDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileModel profile);
}

class FirestoreProfileDataSource implements ProfileDataSource {
  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      throw Exception('User profile not found');
    }
    return UserProfileModel.fromFirestore(snapshot);
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(profile.id)
        .update(profile.toFirestore());
  }
}