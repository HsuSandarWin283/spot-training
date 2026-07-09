import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/models/sport_detail_item.dart';
import 'package:ai_sports_training/src/core/services/sport_detail_service.dart';

final sportDetailServiceProvider = Provider<SportDetailService>((ref) {
  return SportDetailService();
});

final sportsListProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(sportDetailServiceProvider).getSports();
});

final sportInfoProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, sportId) {
  return ref.watch(sportDetailServiceProvider).getSport(sportId);
});

final sportDetailListProvider =
    StreamProvider.family<List<SportDetailItem>, (String, SportDetailType)>(
  (ref, params) {
    final (sportId, type) = params;
    return ref.watch(sportDetailServiceProvider).getItems(sportId, type);
  },
);
