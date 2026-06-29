import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:ai_sports_training/src/features/pose_detection/data/models/pose_detection_result_model.dart';
import 'package:ai_sports_training/src/features/pose_detection/domain/entities/pose_detection_result.dart';
import 'package:ai_sports_training/src/features/pose_detection/domain/repositories/pose_detection_repository.dart';

class AnalyzePose implements UseCase<PoseDetectionResult, AnalyzePoseParams> {
  final PoseDetectionRepository repository;

  AnalyzePose(this.repository);

  @override
  Future<PoseDetectionResult> call(AnalyzePoseParams params) {
    return repository.analyzePose(params.frameData);
  }
}

class AnalyzePoseParams {
  final Map<String, dynamic> frameData;

  AnalyzePoseParams(this.frameData);
}

class SavePoseDetectionResult
    implements UseCase<void, SavePoseDetectionResultParams> {
  final PoseDetectionRepository repository;

  SavePoseDetectionResult(this.repository);

  @override
  Future<void> call(SavePoseDetectionResultParams params) {
    return repository.saveDetectionResult(params.result as PoseDetectionResultModel);
  }
}

class SavePoseDetectionResultParams {
  final PoseDetectionResult result;

  SavePoseDetectionResultParams(this.result);
}

class GetUserPoseHistory
    implements UseCase<List<PoseDetectionResult>, GetUserPoseHistoryParams> {
  final PoseDetectionRepository repository;

  GetUserPoseHistory(this.repository);

  @override
  Future<List<PoseDetectionResult>> call(GetUserPoseHistoryParams params) {
    return repository.getUserDetectionHistory(params.userId);
  }
}

class GetUserPoseHistoryParams {
  final String userId;

  GetUserPoseHistoryParams(this.userId);
}