import 'package:ai_sports_training/src/features/home/data/datasources/sport_data_source.dart';
import 'package:ai_sports_training/src/features/home/domain/entities/sport.dart';
import 'package:ai_sports_training/src/features/home/domain/repositories/sport_repository.dart';

class SportRepositoryImpl implements SportRepository {
  final SportDataSource dataSource;

  SportRepositoryImpl(this.dataSource);

  @override
  Future<List<Sport>> getAllSports() async {
    return dataSource.getAllSports();
  }

  @override
  Future<Sport?> getSportById(String id) async {
    return dataSource.getSportById(id);
  }
}