import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/pose_detection/data/models/pose_detection_result_model.dart';

abstract class PoseDetectionDataSource {
  Future<PoseDetectionResultModel> analyzePose(Map<String, dynamic> frameData);
  Future<void> saveDetectionResult(PoseDetectionResultModel result);
  Future<List<PoseDetectionResultModel>> getUserDetectionHistory(String userId);
}

class FirebasePoseDetectionDataSource implements PoseDetectionDataSource {
  final FirebaseFirestore firestore;

  FirebasePoseDetectionDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<PoseDetectionResultModel> analyzePose(Map<String, dynamic> frameData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PoseDetectionResultModel(
      exerciseId: 'pushup',
      exerciseName: 'Push Up',
      accuracy: 85.5,
      repCount: 10,
      timestamp: DateTime.now(),
      keypoints: frameData,
    );
  }

  @override
  Future<void> saveDetectionResult(PoseDetectionResultModel result) {
    return firestore.collection('pose_results').add(result.toFirestore());
  }

  @override
  Future<List<PoseDetectionResultModel>> getUserDetectionHistory(String userId) async {
    final snapshot = await firestore
        .collection('pose_results')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => PoseDetectionResultModel.fromFirestore(doc)).toList();
  }
}