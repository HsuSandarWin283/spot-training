import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise_step.dart';

class PoseAnalysisResult {
  final Map<String, double> userAngles;
  final double accuracy;
  final Map<String, double> angleDifferences;
  final bool isSuccessful;

  PoseAnalysisResult({
    required this.userAngles,
    required this.accuracy,
    required this.angleDifferences,
    required this.isSuccessful,
  });
}

class PoseAnalysisService {
  static const double _successThreshold = 80;

  PoseAnalysisResult analyze({
    required Pose pose,
    required ExerciseStep referenceStep,
  }) {
    final userAngles = _calculateAngles(pose);
    final result = _compareWithReference(userAngles, referenceStep.poseAngles);
    return result;
  }

  Map<String, double> _calculateAngles(Pose pose) {
    final lm = <String, List<double>>{};

    final mapping = {
      PoseLandmarkType.leftShoulder: 'leftShoulder',
      PoseLandmarkType.rightShoulder: 'rightShoulder',
      PoseLandmarkType.leftElbow: 'leftElbow',
      PoseLandmarkType.rightElbow: 'rightElbow',
      PoseLandmarkType.leftHip: 'leftHip',
      PoseLandmarkType.rightHip: 'rightHip',
      PoseLandmarkType.leftKnee: 'leftKnee',
      PoseLandmarkType.rightKnee: 'rightKnee',
      PoseLandmarkType.leftAnkle: 'leftAnkle',
      PoseLandmarkType.rightAnkle: 'rightAnkle',
      PoseLandmarkType.leftWrist: 'leftWrist',
      PoseLandmarkType.rightWrist: 'rightWrist',
    };

    for (final entry in mapping.entries) {
      final landmark = pose.landmarks[entry.key];
      if (landmark != null) {
        lm[entry.value] = [landmark.x, landmark.y];
      }
    }

    final angles = <String, double>{};

    if (lm['leftShoulder'] != null && lm['leftElbow'] != null && lm['leftHip'] != null) {
      angles['leftElbowAngle'] =
          _calcAngle(lm['leftShoulder']!, lm['leftElbow']!, lm['leftHip']!);
    }
    if (lm['rightShoulder'] != null && lm['rightElbow'] != null && lm['rightHip'] != null) {
      angles['rightElbowAngle'] =
          _calcAngle(lm['rightShoulder']!, lm['rightElbow']!, lm['rightHip']!);
    }
    if (lm['leftHip'] != null && lm['leftKnee'] != null && lm['leftAnkle'] != null) {
      angles['leftKneeAngle'] =
          _calcAngle(lm['leftHip']!, lm['leftKnee']!, lm['leftAnkle']!);
    }
    if (lm['rightHip'] != null && lm['rightKnee'] != null && lm['rightAnkle'] != null) {
      angles['rightKneeAngle'] =
          _calcAngle(lm['rightHip']!, lm['rightKnee']!, lm['rightAnkle']!);
    }
    if (lm['leftShoulder'] != null && lm['rightShoulder'] != null &&
        lm['leftHip'] != null && lm['rightHip'] != null) {
      final sc = [
        (lm['leftShoulder']![0] + lm['rightShoulder']![0]) / 2,
        (lm['leftShoulder']![1] + lm['rightShoulder']![1]) / 2,
      ];
      final hc = [
        (lm['leftHip']![0] + lm['rightHip']![0]) / 2,
        (lm['leftHip']![1] + lm['rightHip']![1]) / 2,
      ];
      angles['bodyTilt'] = _calcAngle([hc[0], hc[1] - 100], hc, sc);
    }

    return angles;
  }

  double _calcAngle(List<double> a, List<double> b, List<double> c) {
    final ba = [a[0] - b[0], a[1] - b[1]];
    final bc = [c[0] - b[0], c[1] - b[1]];
    final dot = ba[0] * bc[0] + ba[1] * bc[1];
    final magBA = sqrt(ba[0] * ba[0] + ba[1] * ba[1]);
    final magBC = sqrt(bc[0] * bc[0] + bc[1] * bc[1]);
    if (magBA == 0 || magBC == 0) return 0;
    var cos = dot / (magBA * magBC);
    cos = max(-1.0, min(1.0, cos));
    return (acos(cos) * 180 / pi).roundToDouble();
  }

  PoseAnalysisResult _compareWithReference(
      Map<String, double> userAngles, Map<String, double> refAngles) {
    if (refAngles.isEmpty) {
      return PoseAnalysisResult(
        userAngles: userAngles,
        accuracy: 0,
        angleDifferences: {},
        isSuccessful: false,
      );
    }

    final diffs = <String, double>{};
    double totalDiff = 0;
    int count = 0;

    for (final entry in refAngles.entries) {
      final userAngle = userAngles[entry.key];
      if (userAngle == null) continue;
      final diff = (entry.value - userAngle).abs();
      diffs[entry.key] = diff;
      totalDiff += diff;
      count++;
    }

    if (count == 0) {
      return PoseAnalysisResult(
        userAngles: userAngles,
        accuracy: 0,
        angleDifferences: {},
        isSuccessful: false,
      );
    }

    final avgDiff = totalDiff / count;
    final accuracy = max(0.0, 100 - (avgDiff / 45 * 100)).clamp(0.0, 100.0);

    return PoseAnalysisResult(
      userAngles: userAngles,
      accuracy: accuracy,
      angleDifferences: diffs,
      isSuccessful: accuracy >= _successThreshold,
    );
  }

  List<String> detectRequiredCorrections({
    required Map<String, double> userAngles,
    required Map<String, double> refAngles,
  }) {
    final corrections = <String>[];

    for (final entry in refAngles.entries) {
      final userAngle = userAngles[entry.key];
      if (userAngle == null) continue;

      final diff = (entry.value - userAngle).abs();
      if (diff < 10) continue;

      final correction = _getCorrection(entry.key, userAngle, entry.value);
      if (correction != null) corrections.add(correction);
    }

    return corrections;
  }

  String? _getCorrection(String angleName, double user, double ref) {
    final direction = user > ref ? 'lower' : 'raise';

    switch (angleName) {
      case 'leftElbowAngle':
        return direction == 'raise' ? 'Raise your left arm' : 'Lower your left arm';
      case 'rightElbowAngle':
        return direction == 'raise' ? 'Raise your right arm' : 'Lower your right arm';
      case 'leftKneeAngle':
        return direction == 'raise' ? 'Straighten your left leg' : 'Bend your left knee';
      case 'rightKneeAngle':
        return direction == 'raise' ? 'Straighten your right leg' : 'Bend your right knee';
      case 'bodyTilt':
        return user > ref ? 'Straighten your back' : 'Lean forward slightly';
      default:
        return null;
    }
  }
}
