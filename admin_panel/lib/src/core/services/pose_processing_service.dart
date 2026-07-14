// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:js' as js;

class PoseProcessingResult {
  final Map<String, List<double>> landmarks;
  final Map<String, double> angles;

  PoseProcessingResult({
    required this.landmarks,
    required this.angles,
  });
}

class PoseProcessingService {
  Future<PoseProcessingResult> processImage(Uint8List imageBytes) async {
    final base64Image = base64Encode(imageBytes);

    for (int attempt = 0; attempt < 10; attempt++) {
      final func = js.context['detectPoseBase64'];
      if (func != null) break;
      if (attempt == 9) {
        throw PoseProcessingException(
          'Pose detection not loaded. Please refresh the page and try again.',
        );
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    js.context['_poseResult'] = null;
    js.context['_poseDone'] = false;
    js.context['_poseErrorMsg'] = null;

    js.context.callMethod('detectPoseBase64', [base64Image]);

    for (int i = 0; i < 600; i++) {
      final done = js.context['_poseDone'];
      if (done == true) break;
      final errorMsg = js.context['_poseErrorMsg'];
      if (errorMsg != null && errorMsg != false && errorMsg.toString().isNotEmpty) {
        throw PoseProcessingException(errorMsg.toString());
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final done = js.context['_poseDone'];
    if (done != true) {
      throw PoseProcessingException('Pose detection timed out (30s). Try a smaller image.');
    }

    final errorMsg = js.context['_poseErrorMsg'];
    if (errorMsg != null && errorMsg.toString().isNotEmpty) {
      throw PoseProcessingException(errorMsg.toString());
    }

    final rawResult = js.context['_poseResult'] as String?;
    if (rawResult == null) {
      throw PoseProcessingException('No result from pose detection');
    }

    final data = jsonDecode(rawResult) as Map<String, dynamic>;

    if (data['success'] != true) {
      throw PoseProcessingException(data['error'] ?? 'Pose processing failed');
    }

    final rawLandmarks = Map<String, dynamic>.from(data['landmarks'] ?? {});
    final landmarks = <String, List<double>>{};
    for (final entry in rawLandmarks.entries) {
      if (entry.value is List) {
        landmarks[entry.key] =
            (entry.value as List).map((e) => (e as num).toDouble()).toList();
      }
    }

    final rawAngles = Map<String, dynamic>.from(data['angles'] ?? {});
    final angles = <String, double>{};
    for (final entry in rawAngles.entries) {
      if (entry.value is num) {
        angles[entry.key] = (entry.value as num).toDouble();
      }
    }

    if (landmarks.isEmpty) {
      throw PoseProcessingException('No body landmarks detected in image');
    }

    return PoseProcessingResult(landmarks: landmarks, angles: angles);
  }

  static bool validateLandmarks(Map<String, List<double>> landmarks) {
    const required = [
      'leftShoulder',
      'rightShoulder',
      'leftHip',
      'rightHip',
      'leftKnee',
      'rightKnee',
    ];
    for (final name in required) {
      final lm = landmarks[name];
      if (lm == null || lm.length < 2) return false;
    }
    return true;
  }
}

class PoseProcessingException implements Exception {
  final String message;
  PoseProcessingException(this.message);

  @override
  String toString() => message;
}
