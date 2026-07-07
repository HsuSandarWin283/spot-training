import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';

final sportServiceProvider = Provider<SportService>((ref) => SportService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(sportServiceProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(data: (user) => user);
});
