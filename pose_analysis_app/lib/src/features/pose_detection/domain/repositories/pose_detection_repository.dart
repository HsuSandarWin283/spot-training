import 'package:ai_sports_training/src/features/pose_detection/domain/entities/pose_detection_result.dart';

abstract class PoseDetectionRepository {
  Future<PoseDetectionResult> analyzePose(Map<String, dynamic> frameData);
  Future<void> saveDetectionResult(PoseDetectionResult result);
  Future<List<PoseDetectionResult>> getUserDetectionHistory(String userId);
}