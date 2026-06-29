import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:ai_sports_training/src/features/home/domain/entities/sport.dart';
import 'package:ai_sports_training/src/features/home/domain/repositories/sport_repository.dart';

class GetAllSports implements UseCase<List<Sport>, NoParams> {
  final SportRepository repository;

  GetAllSports(this.repository);

  @override
  Future<List<Sport>> call(NoParams params) {
    return repository.getAllSports();
  }
}

class GetSportById implements UseCase<Sport?, GetSportByIdParams> {
  final SportRepository repository;

  GetSportById(this.repository);

  @override
  Future<Sport?> call(GetSportByIdParams params) {
    return repository.getSportById(params.id);
  }
}

class GetSportByIdParams {
  final String id;

  GetSportByIdParams(this.id);
}