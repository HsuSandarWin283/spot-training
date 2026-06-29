import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';
import 'package:ai_sports_training/src/features/auth/domain/usecases/auth_usecases.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

final signInProvider = FutureProvider.autoDispose.family<User, SignInParams>((ref, params) async {
  final useCase = SignInWithEmailAndPassword(ref.read(authRepositoryProvider));
  return useCase(params);
});

final signUpProvider = FutureProvider.autoDispose.family<User, SignUpParams>((ref, params) async {
  final useCase = SignUpWithEmailAndPassword(ref.read(authRepositoryProvider));
  return useCase(params);
});

final signOutProvider = FutureProvider.autoDispose<void>((ref) async {
  final useCase = SignOut(ref.read(authRepositoryProvider));
  return useCase(NoParams());
});