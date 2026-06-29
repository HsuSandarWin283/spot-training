import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/profile/data/datasources/profile_data_source.dart';
import 'package:ai_sports_training/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ai_sports_training/src/features/profile/domain/repositories/profile_repository.dart';

final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  return FirestoreProfileDataSource();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.read(profileDataSourceProvider));
});