import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/providers/exercise_flow_providers.dart';
import 'package:ai_sports_training/src/features/exercise_flow/ui/pages/exercise_completion_screen.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExerciseFlowScreen extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseFlowScreen({super.key, required this.exercise});

  @override
  ConsumerState<ExerciseFlowScreen> createState() =>
      _ExerciseFlowScreenState();
}

class _ExerciseFlowScreenState extends ConsumerState<ExerciseFlowScreen> {
  CameraController? _cameraController;
  PoseDetector? _poseDetector;
  bool _isProcessing = false;
  bool _cameraReady = false;
  bool _voiceEnabled = true;
  bool _permissionGranted = false;
  bool _permissionChecked = false;
  Timer? _autoNextTimer;
  String _currentFeedback = '';

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
        _permissionChecked = true;
      });
      _initCamera();
      return;
    }
    final result = await Permission.camera.request();
    setState(() {
      _permissionGranted = result.isGranted;
      _permissionChecked = true;
    });
    if (result.isGranted) _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _cameraController!.initialize();

      _poseDetector = PoseDetector(
        options: PoseDetectorOptions(
          model: PoseDetectionModel.accurate,
          mode: PoseDetectionMode.stream,
        ),
      );

      await ref.read(voiceCoachingServiceProvider).init();
      debugPrint('ExerciseFlow: TTS initialized, camera ready');

      if (mounted) {
        setState(() => _cameraReady = true);
        _startImageStream();
      }
    } catch (e) {
      debugPrint('ExerciseFlow: init error: $e');
      if (mounted) {
        setState(() => _cameraReady = false);
      }
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isProcessing || _poseDetector == null || !mounted) return;

      final stepState = ref.read(stepControllerProvider(widget.exercise.steps));
      if (stepState.isStepComplete || stepState.isExerciseComplete) return;

      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage == null) {
          _isProcessing = false;
          return;
        }

        final poses = await _poseDetector!.processImage(inputImage);

        if (poses.isNotEmpty && mounted) {
          debugPrint('ExerciseFlow: Pose detected, analyzing...');
          final result = ref
              .read(poseAnalysisServiceProvider)
              .analyze(
                pose: poses.first,
                referenceStep: stepState.currentStep!,
              );

          final voiceService = ref.read(voiceCoachingServiceProvider);
          voiceService.setEnabled(_voiceEnabled);
          final langCode = ref.read(localeProvider).languageCode;

          if (result.isSuccessful) {
            ref.read(stepControllerProvider(widget.exercise.steps).notifier)
                .onStepSuccess(result.accuracy, result.angleDifferences);

            voiceService.speakSuccess(languageCode: langCode);

            if (mounted) {
              setState(() => _currentFeedback = AppLocalizations.of(context)!.stepComplete);

              if (stepState.isAutoNext) {
                _autoNextTimer = Timer(const Duration(seconds: 1), () {
                  _advanceStep();
                });
              }
            }
          } else {
            final corrections = ref
                .read(poseAnalysisServiceProvider)
                .detectRequiredCorrections(
                  userAngles: result.userAngles,
                  refAngles: stepState.currentStep!.poseAngles,
                );

            voiceService.speakFeedback(corrections, languageCode: langCode);

            if (mounted && corrections.isNotEmpty) {
              setState(() => _currentFeedback = corrections.first);
            }
          }
        } else if (mounted) {
          setState(() => _currentFeedback = AppLocalizations.of(context)!.noPersonDetected);
        }
      } catch (_) {}

      _isProcessing = false;
    });
  }

  void _advanceStep() {
    _autoNextTimer?.cancel();
    final notifier =
        ref.read(stepControllerProvider(widget.exercise.steps).notifier);
    final state = ref.read(stepControllerProvider(widget.exercise.steps));

    if (state.isLastStep || state.isExerciseComplete) {
      notifier.nextStep();
      _finishExercise();
    } else {
      notifier.nextStep();
      ref.read(voiceCoachingServiceProvider).reset();
      if (mounted) setState(() => _currentFeedback = '');
    }
  }

  void _onManualNext() {
    final state = ref.read(stepControllerProvider(widget.exercise.steps));
    if (state.isLastStep) {
      ref
          .read(stepControllerProvider(widget.exercise.steps).notifier)
          .nextStep();
      _finishExercise();
    } else {
      _advanceStep();
    }
  }

  void _finishExercise() {
    _cameraController?.stopImageStream();
    ref.read(voiceCoachingServiceProvider).speakExerciseComplete(
      languageCode: ref.read(localeProvider).languageCode,
    );

    final stepNotifier =
        ref.read(stepControllerProvider(widget.exercise.steps).notifier);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ExerciseCompletionScreen(
          exercise: widget.exercise,
          overallAccuracy: stepNotifier.overallAccuracy,
          totalDuration: stepNotifier.totalElapsed,
          estimatedCalories: stepNotifier.estimatedCalories,
          stepResults: stepNotifier.stepResults,
        ),
      ),
    );
  }

  InputImage? _convertCameraImage(CameraImage image) {
    final rotation = InputImageRotationValue.fromRawValue(
      _cameraController!.description.sensorOrientation,
    );
    if (rotation == null) return null;

    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseDetector?.close();
    ref.read(voiceCoachingServiceProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionChecked) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (!_permissionGranted) {
      return _buildPermissionDenied();
    }

    final steps = widget.exercise.steps;
    final stepState = ref.watch(stepControllerProvider(steps));

    if (stepState.isExerciseComplete) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraReady && _cameraController != null)
            ClipRect(child: _cameraController!.buildPreview())
          else
            Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          _buildTopBar(stepState),
          _buildReferenceImage(stepState),
          _buildCoachingOverlay(stepState),
          _buildBottomBar(stepState),
          if (stepState.isStepComplete) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopBar(ExerciseStepState stepState) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 24),
              onPressed: () {
                ref.read(voiceCoachingServiceProvider).dispose();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    stepState.currentStep?.title ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${stepState.currentStepIndex + 1}/${stepState.totalSteps}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _voiceEnabled = !_voiceEnabled),
              child: Icon(
                _voiceEnabled ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceImage(ExerciseStepState stepState) {
    final imageUrl = stepState.currentStep?.imageUrl ?? '';
    if (imageUrl.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      right: 12,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: stepState.isStepComplete
                ? AppColors.success
                : Colors.white.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: 100,
            height: 130,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 100,
              height: 130,
              color: Colors.white.withOpacity(0.1),
              child: const Icon(Icons.image, color: Colors.white54, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoachingOverlay(ExerciseStepState stepState) {
    if (_currentFeedback.isEmpty || stepState.isStepComplete) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      left: 12,
      right: 130,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.mic, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _currentFeedback,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ExerciseStepState stepState) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAccuracyBar(stepState),
              const SizedBox(height: 12),
              if (stepState.isStepComplete)
                if (!stepState.isAutoNext || stepState.isLastStep)
                  GradientButton(
                    text: stepState.isLastStep ? AppLocalizations.of(context)!.finish : AppLocalizations.of(context)!.nextStep,
                    icon: Icons.arrow_forward,
                    onPressed: _onManualNext,
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.autoAdvancing,
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
              else
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.matchReferencePose,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccuracyBar(ExerciseStepState stepState) {
    final color = stepState.accuracy >= 90
        ? AppColors.success
        : stepState.accuracy >= 50
            ? AppColors.warning
            : AppColors.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stepState.isStepComplete
                  ? AppLocalizations.of(context)!.stepComplete
                  : (_currentFeedback.isEmpty ? AppLocalizations.of(context)!.analyzing : _currentFeedback),
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
            ),
            Text(
              '${stepState.accuracy.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: stepState.accuracy / 100,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessOverlay() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 130,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.stepCompleted,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.bg(context), AppColors.surf(context)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.videocam_off,
                          size: 64, color: AppColors.error),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.cameraPermissionRequired,
                      style: TextStyle(
                        color: AppColors.txtPrimary(context),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.cameraPermissionDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.txtSecondary(context), fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    GradientButton(
                      text: AppLocalizations.of(context)!.grantPermission,
                      icon: Icons.camera_alt,
                      onPressed: _requestPermission,
                    ),
                    const SizedBox(height: 12),
                    OutlineButton(
                      text: AppLocalizations.of(context)!.goBack,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
