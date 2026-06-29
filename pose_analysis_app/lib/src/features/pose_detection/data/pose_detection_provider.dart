import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/pose_detection/data/datasources/pose_detection_data_source.dart';
import 'package:ai_sports_training/src/features/pose_detection/data/repositories/pose_detection_repository_impl.dart';
import 'package:ai_sports_training/src/features/pose_detection/domain/repositories/pose_detection_repository.dart';

final poseDetectionDataSourceProvider = Provider<PoseDetectionDataSource>((ref) {
  return FirebasePoseDetectionDataSource();
});

final poseDetectionRepositoryProvider = Provider<PoseDetectionRepository>((ref) {
  return PoseDetectionRepositoryImpl(ref.read(poseDetectionDataSourceProvider));
});