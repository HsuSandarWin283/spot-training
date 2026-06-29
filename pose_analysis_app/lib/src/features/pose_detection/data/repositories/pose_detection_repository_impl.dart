import 'package:ai_sports_training/src/features/pose_detection/data/datasources/pose_detection_data_source.dart';
import 'package:ai_sports_training/src/features/pose_detection/data/models/pose_detection_result_model.dart';
import 'package:ai_sports_training/src/features/pose_detection/domain/entities/pose_detection_result.dart';
import 'package:ai_sports_training/src/features/pose_detection/domain/repositories/pose_detection_repository.dart';

class PoseDetectionRepositoryImpl implements PoseDetectionRepository {
  final PoseDetectionDataSource dataSource;

  PoseDetectionRepositoryImpl(this.dataSource);

  @override
  Future<PoseDetectionResult> analyzePose(Map<String, dynamic> frameData) {
    return dataSource.analyzePose(frameData);
  }

  @override
  Future<void> saveDetectionResult(PoseDetectionResult result) {
    return dataSource.saveDetectionResult(result as PoseDetectionResultModel);
  }

  @override
  Future<List<PoseDetectionResult>> getUserDetectionHistory(String userId) {
    return dataSource.getUserDetectionHistory(userId);
  }
}