import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/auth/data/datasources/auth_data_source.dart';
import 'package:ai_sports_training/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ai_sports_training/src/features/auth/domain/repositories/auth_repository.dart';

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSourceProvider));
});

final authStateProvider = StreamProvider.autoDispose((ref) {
  return ref.read(authRepositoryProvider).userChanges;
});