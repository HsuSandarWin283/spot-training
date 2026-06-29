import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/pose_detection/domain/entities/pose_detection_result.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';

class PoseDetectionPage extends ConsumerStatefulWidget {
  const PoseDetectionPage({super.key});

  @override
  ConsumerState<PoseDetectionPage> createState() => _PoseDetectionPageState();
}

class _PoseDetectionPageState extends ConsumerState<PoseDetectionPage> {
  bool _isDetecting = false;
  PoseDetectionResult? _result;

  void _startDetection() async {
    setState(() => _isDetecting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _result = PoseDetectionResult(
          exerciseId: 'squat',
          exerciseName: 'Squat',
          accuracy: 92.3,
          repCount: 15,
          timestamp: DateTime.now(),
          keypoints: {},
        );
        _isDetecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToMain(),
        ),
        title: const Text('Pose Detection'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isDetecting
                  ? const CircularProgressIndicator()
                  : _result != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _result!.exerciseName,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text('Accuracy: ${_result!.accuracy}%'),
                            Text('Reps: ${_result!.repCount}'),
                          ],
                        )
                      : const Icon(Icons.camera_alt, size: 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: _isDetecting ? null : _startDetection,
              icon: const Icon(Icons.play_arrow),
              label: Text(_isDetecting ? 'Detecting...' : 'Start Detection'),
            ),
          ),
        ],
      ),
    );
  }
}