import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/auth/data/datasources/auth_data_source.dart';
import 'package:ai_sports_training/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';
import 'package:ai_sports_training/src/features/auth/domain/repositories/auth_repository.dart';

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSourceProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(
    data: (user) => user,
  );
});
