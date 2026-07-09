import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/models/sport_detail_models.dart';
import 'package:admin_panel/src/core/services/sport_detail_service.dart';

final sportDetailServiceProvider = Provider<SportDetailService>((ref) {
  return SportDetailService();
});

final sportDetailListProvider =
    StreamProvider.family<List<SportDetailItem>, (String, SportDetailType)>(
  (ref, params) {
    final (sportId, type) = params;
    return ref.watch(sportDetailServiceProvider).getItems(sportId, type);
  },
);

final selectedSportDetailItemProvider =
    StateProvider<SportDetailItem?>((ref) => null);

final selectedSportIdProvider = StateProvider<String>((ref) => '');

final selectedSportNameProvider = StateProvider<String>((ref) => '');

final sportDetailSearchQueryProvider = StateProvider<String>((ref) => '');

final currentDetailTypeProvider =
    StateProvider<SportDetailType>((ref) => SportDetailType.rules);
