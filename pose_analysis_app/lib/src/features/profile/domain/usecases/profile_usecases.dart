import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:ai_sports_training/src/features/profile/data/models/user_profile_model.dart';
import 'package:ai_sports_training/src/features/profile/domain/entities/user_profile.dart';
import 'package:ai_sports_training/src/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfile implements UseCase<UserProfile, GetUserProfileParams> {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<UserProfile> call(GetUserProfileParams params) {
    return repository.getUserProfile(params.userId);
  }
}

class GetUserProfileParams {
  final String userId;

  GetUserProfileParams(this.userId);
}

class UpdateUserProfile implements UseCase<void, UpdateUserProfileParams> {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<void> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(params.profile as UserProfileModel);
  }
}

class UpdateUserProfileParams {
  final UserProfile profile;

  UpdateUserProfileParams(this.profile);
}