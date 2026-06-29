part of 'pose_detection_result_model.dart';

PoseDetectionResultModel _$PoseDetectionResultModelFromJson(Map<String, dynamic> json) => PoseDetectionResultModel(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      accuracy: (json['accuracy'] as num).toDouble(),
      repCount: json['repCount'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      keypoints: Map<String, dynamic>.from(json['keypoints'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PoseDetectionResultModelToJson(PoseDetectionResultModel instance) => <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'exerciseName': instance.exerciseName,
      'accuracy': instance.accuracy,
      'repCount': instance.repCount,
      'timestamp': instance.timestamp.toIso8601String(),
      'keypoints': instance.keypoints,
    };