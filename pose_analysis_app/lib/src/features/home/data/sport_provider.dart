import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/home/data/datasources/sport_data_source.dart';
import 'package:ai_sports_training/src/features/home/data/repositories/sport_repository_impl.dart';
import 'package:ai_sports_training/src/features/home/domain/repositories/sport_repository.dart';

final sportDataSourceProvider = Provider<SportDataSource>((ref) {
  return FirestoreSportDataSource();
});

final sportRepositoryProvider = Provider<SportRepository>((ref) {
  return SportRepositoryImpl(ref.read(sportDataSourceProvider));
});