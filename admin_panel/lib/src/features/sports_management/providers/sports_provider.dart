import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';

final sportsListProvider = StreamProvider<List<SportModel>>((ref) {
  return ref.watch(sportServiceProvider).getSports();
});

final selectedSportProvider = StateProvider<SportModel?>((ref) => null);
