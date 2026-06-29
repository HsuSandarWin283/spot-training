import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ai_sports_training/src/features/pose_detection/domain/entities/pose_detection_result.dart';

part 'pose_detection_result_model.g.dart';

@JsonSerializable()
class PoseDetectionResultModel extends PoseDetectionResult {
  const PoseDetectionResultModel({
    required super.exerciseId,
    required super.exerciseName,
    required super.accuracy,
    required super.repCount,
    required super.timestamp,
    required super.keypoints,
  });

  factory PoseDetectionResultModel.fromJson(Map<String, dynamic> json) =>
      _$PoseDetectionResultModelFromJson(json);

  factory PoseDetectionResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PoseDetectionResultModel(
      exerciseId: data['exerciseId'] ?? '',
      exerciseName: data['exerciseName'] ?? '',
      accuracy: (data['accuracy'] ?? 0).toDouble(),
      repCount: data['repCount'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      keypoints: Map<String, dynamic>.from(data['keypoints'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() => _$PoseDetectionResultModelToJson(this);
}