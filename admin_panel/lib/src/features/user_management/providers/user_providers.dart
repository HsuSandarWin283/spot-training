import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final usersProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(userServiceProvider).getUsers();
});
