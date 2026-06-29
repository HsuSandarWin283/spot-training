import 'package:ai_sports_training/src/features/profile/data/datasources/profile_data_source.dart';
import 'package:ai_sports_training/src/features/profile/data/models/user_profile_model.dart';
import 'package:ai_sports_training/src/features/profile/domain/entities/user_profile.dart';
import 'package:ai_sports_training/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<UserProfile> getUserProfile(String userId) {
    return dataSource.getUserProfile(userId);
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) {
    return dataSource.updateUserProfile(profile as UserProfileModel);
  }
}