import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/models/injury_item.dart';
import 'package:ai_sports_training/src/core/services/injury_service.dart';

final injuryServiceProvider = Provider<InjuryService>((ref) {
  return InjuryService();
});

final injuryListProvider =
    StreamProvider.family<List<InjuryItem>, InjuryDataType>((ref, type) {
  return ref.watch(injuryServiceProvider).getItems(type);
});
