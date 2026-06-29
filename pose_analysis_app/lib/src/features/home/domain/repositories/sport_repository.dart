import 'package:ai_sports_training/src/features/home/domain/entities/sport.dart';

abstract class SportRepository {
  Future<List<Sport>> getAllSports();
  Future<Sport?> getSportById(String id);
}