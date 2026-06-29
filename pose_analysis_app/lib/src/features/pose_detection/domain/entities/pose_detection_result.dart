import 'package:equatable/equatable.dart';

class PoseDetectionResult extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final double accuracy;
  final int repCount;
  final DateTime timestamp;
  final Map<String, dynamic> keypoints;

  const PoseDetectionResult({
    required this.exerciseId,
    required this.exerciseName,
    required this.accuracy,
    required this.repCount,
    required this.timestamp,
    required this.keypoints,
  });

  @override
  List<Object?> get props => [exerciseId, exerciseName, accuracy, repCount, timestamp, keypoints];
}