import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/models/injury_item.dart';
import 'package:admin_panel/src/core/services/injury_service.dart';

final injuryServiceProvider = Provider<InjuryService>((ref) {
  return InjuryService();
});

final injuryListProvider =
    StreamProvider.family<List<InjuryItem>, InjuryDataType>((ref, type) {
  return ref.watch(injuryServiceProvider).getItems(type);
});

final injurySearchQueryProvider = StateProvider<String>((ref) => '');

final currentInjuryTypeProvider =
    StateProvider<InjuryDataType>((ref) => InjuryDataType.prevention);

final selectedInjuryItemProvider = StateProvider<InjuryItem?>((ref) => null);
