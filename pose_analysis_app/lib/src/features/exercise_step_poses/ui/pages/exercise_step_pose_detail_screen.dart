// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:ai_sports_training/src/core/services/cloud_tts_service.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/models/exercise_step_image_post.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/providers/exercise_step_image_providers.dart';
import 'package:permission_handler/permission_handler.dart';

class ExerciseStepPoseDetailScreen extends ConsumerWidget {
  final String postId;

  const ExerciseStepPoseDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(exerciseStepImageItemsProvider(postId));

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0E21), Color(0xFF151A30)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const CustomAppBar(title: 'Step by Step', showBack: true),
                const SizedBox(height: 8),
                Expanded(
                  child: itemsAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _StepCard(
                            stepOrder: item.stepOrder,
                            imageUrl: item.imageUrl,
                            description: item.description,
                            isLast: index == items.length - 1,
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    ),
                    error: (error, _) => _buildErrorState(error),
                  ),
                ),
                itemsAsync.when(
                  data: (items) {
                    if (items.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: GradientButton(
                        text: 'Start Practice',
                        icon: Icons.play_arrow,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PosePracticeScreen(
                                items: items,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.image_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Steps Available',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Step images will appear here once added.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to Load Steps',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepOrder;
  final String imageUrl;
  final String description;
  final bool isLast;

  const _StepCard({
    required this.stepOrder,
    required this.imageUrl,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$stepOrder',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.6),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                        ),
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.textMuted,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                if (description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PosePracticeScreen extends StatefulWidget {
  final List<ExerciseStepImageItem> items;

  const PosePracticeScreen({super.key, required this.items});

  @override
  State<PosePracticeScreen> createState() => _PosePracticeScreenState();
}

class _PosePracticeScreenState extends State<PosePracticeScreen> {
  int _currentStepIndex = 0;
  int _currentItemIndexInStep = 0;
  double _accuracy = 0;
  bool _stepComplete = false;
  bool _allDone = false;
  String _feedback = '';
  bool _cameraPermissionGranted = false;
  bool _permissionChecked = false;
  bool _autoAdvancing = false;
  Timer? _autoAdvanceTimer;

  late List<List<ExerciseStepImageItem>> _steps;

  List<ExerciseStepImageItem> get _currentStepItems => _steps[_currentStepIndex];
  ExerciseStepImageItem get _currentItem => _currentStepItems[_currentItemIndexInStep];
  bool get _isLastItemInStep => _currentItemIndexInStep >= _currentStepItems.length - 1;
  bool get _isLastStep => _currentStepIndex >= _steps.length - 1;

  @override
  void initState() {
    super.initState();
    _groupItemsByStep();
    _requestCameraPermission();
  }

  void _groupItemsByStep() {
    final sorted = List<ExerciseStepImageItem>.from(widget.items)
      ..sort((a, b) {
        final stepCmp = a.stepNumber.compareTo(b.stepNumber);
        if (stepCmp != 0) return stepCmp;
        return a.stepOrder.compareTo(b.stepOrder);
      });

    final map = <int, List<ExerciseStepImageItem>>{};
    for (final item in sorted) {
      map.putIfAbsent(item.stepNumber, () => []).add(item);
    }

    final entries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    _steps = entries.map((e) => e.value).toList();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _cameraPermissionGranted = true;
        _permissionChecked = true;
      });
      return;
    }

    final result = await Permission.camera.request();
    setState(() {
      _cameraPermissionGranted = result.isGranted;
      _permissionChecked = true;
    });
  }

  void _onItemMatched() {
    if (_isLastItemInStep) {
      setState(() => _stepComplete = true);
    } else {
      setState(() {
        _autoAdvancing = true;
        _stepComplete = true;
      });
      _autoAdvanceTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _currentItemIndexInStep++;
            _accuracy = 0;
            _feedback = '';
            _stepComplete = false;
            _autoAdvancing = false;
          });
        }
      });
    }
  }

  void _onNextStep() {
    if (_isLastStep) {
      setState(() => _allDone = true);
    } else {
      setState(() {
        _currentStepIndex++;
        _currentItemIndexInStep = 0;
        _accuracy = 0;
        _stepComplete = false;
        _feedback = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allDone) {
      return _buildCompletionScreen();
    }

    if (!_permissionChecked) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (!_cameraPermissionGranted) {
      return _buildPermissionDeniedScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PoseCameraView(
            key: ValueKey('$_currentStepIndex-$_currentItemIndexInStep'),
            stepAngles: _currentItem.poseAngles,
            onResult: (accuracy, feedback) {
              if (mounted && !_stepComplete) {
                setState(() {
                  _accuracy = accuracy;
                  _feedback = feedback;
                  if (accuracy >= 90) {
                    _onItemMatched();
                  }
                });
              }
            },
          ),
          Positioned(
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
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Step ${_currentStepItems.first.stepNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _currentItem.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentItemIndexInStep + 1}/${_currentStepItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_currentItem.imageUrl.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).padding.top + 70,
              right: 12,
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _stepComplete
                        ? AppColors.success
                        : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _currentItem.imageUrl,
                    width: 100,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 130,
                      color: Colors.white.withOpacity(0.1),
                      child: const Icon(Icons.image,
                          color: Colors.white54, size: 30),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAccuracyBar(),
                    const SizedBox(height: 12),
                    if (_stepComplete && _autoAdvancing)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.success,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Auto-advancing in 5s...',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_stepComplete)
                      GradientButton(
                        text: _isLastStep ? 'Finish' : 'Next Step',
                        icon: Icons.arrow_forward,
                        onPressed: _onNextStep,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
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
                              _isLastItemInStep
                                  ? 'Match the pose to complete step...'
                                  : 'Match the pose to continue...',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (_stepComplete)
            Positioned(
              top: MediaQuery.of(context).padding.top + 70,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _autoAdvancing
                          ? 'Image Complete! Next in 5s...'
                          : (_isLastStep ? 'All Steps Complete!' : 'Step Complete!'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccuracyBar() {
    final color = _accuracy >= 90
        ? AppColors.success
        : _accuracy >= 40
            ? AppColors.warning
            : AppColors.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _feedback.isEmpty ? 'Analyzing pose...' : _feedback,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            Text(
              '${_accuracy.toStringAsFixed(0)}%',
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
            value: _accuracy / 100,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDeniedScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0E21), Color(0xFF151A30)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.videocam_off,
                        size: 64,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Camera Permission Required',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This feature needs camera access to detect your pose and compare with the reference.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GradientButton(
                      text: 'Grant Permission',
                      icon: Icons.camera_alt,
                      onPressed: _requestCameraPermission,
                    ),
                    const SizedBox(height: 12),
                    OutlineButton(
                      text: 'Go Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => openAppSettings(),
                      child: const Text(
                        'Open App Settings',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
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

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0E21), Color(0xFF151A30)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 64,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'All Steps Complete!',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You completed all ${_steps.length} steps (${widget.items.length} images).',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    GradientButton(
                      text: 'Done',
                      icon: Icons.check,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 12),
                    OutlineButton(
                      text: 'Practice Again',
                      onPressed: () {
                        setState(() {
                          _currentStepIndex = 0;
                          _currentItemIndexInStep = 0;
                          _accuracy = 0;
                          _stepComplete = false;
                          _allDone = false;
                          _feedback = '';
                        });
                      },
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

class PoseCameraView extends StatefulWidget {
  final Map<String, double> stepAngles;
  final Function(double accuracy, String feedback) onResult;

  const PoseCameraView({
    super.key,
    required this.stepAngles,
    required this.onResult,
  });

  @override
  State<PoseCameraView> createState() => _PoseCameraViewState();
}

class _PoseCameraViewState extends State<PoseCameraView> {
  CameraController? _cameraController;
  PoseDetector? _poseDetector;
  bool _isProcessing = false;
  bool _isInitialized = false;
  String _error = '';
  final CloudTtsService _cloudTts = CloudTtsService();
  String _lastFeedback = '';

  @override
  void initState() {
    super.initState();
    _initTts();
    _initCamera();
  }

  Future<void> _initTts() async {
    try {
      await _cloudTts.init();
      debugPrint('PoseCameraView: Cloud TTS ready');
    } catch (e) {
      debugPrint('PoseCameraView: TTS init error: $e');
    }
  }

  Future<void> _speakMyanmar(String english) async {
    final text = _toMyanmar(english);
    if (text == _lastFeedback || _cloudTts.isPlaying) return;
    _lastFeedback = text;
    await _cloudTts.speak(text: text, languageCode: 'my-MM');
  }

  String _toMyanmar(String english) {
    const map = {
      'Raise your left arm': 'ဘယ်ဘက်လက်ကို အပေါ်ဘက် မြှောက်ပါ',
      'Lower your left arm': 'ဘယ်ဘက်လက်ကို အောက်ချပါ',
      'Raise your right arm': 'ညာဘက်လက်ကို အပေါ်ဘက် မြှောက်ပါ',
      'Lower your right arm': 'ညာဘက်လက်ကို အောက်ချပါ',
      'Straighten your left leg': 'ဘယ်ဘက်ဒူးကို ဆန့်တန်းပါ',
      'Bend your left knee': 'ဘယ်ဘက်ဒူးကို ကွေးပါ',
      'Straighten your right leg': 'ညာဘက်ဒူးကို ဆန့်တန်းပါ',
      'Bend your right knee': 'ညာဘက်ဒူးကို ကွေးပါ',
      'Straighten your back': 'ကျောကို တည့်တည့်ထားပါ',
      'Match the reference pose': 'ပုံတူကူးပါ',
      'Step back to show full body': 'ခြေလှမ်းနောက်ဆုတ်ပါ',
      'No person detected': 'လူတစ်ယောက် မတွေ့ပါ။ ကင်မရာရှေ့ ရပ်ပါ',
      'Excellent alignment!': 'အလွန်ကောင်းပါသည်',
      'Step Complete!': 'ဆင့်ပြီးပါပြီ။ နောက်တစ်ဆင့်သို့ ဆက်သွားနိုင်ပါပြီ',
    };
    return map[english] ?? english;
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

      if (mounted) {
        setState(() => _isInitialized = true);
        _startImageStream();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Camera init failed: $e');
      }
    }
  }

  static const _requiredLandmarks = [
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.leftHip,
    PoseLandmarkType.rightHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.leftAnkle,
    PoseLandmarkType.rightAnkle,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.rightElbow,
  ];

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isProcessing || _poseDetector == null) return;
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage == null) {
          _isProcessing = false;
          return;
        }

        final poses = await _poseDetector!.processImage(inputImage);

        if (poses.isNotEmpty && mounted) {
          final pose = poses.first;

          final detectedCount = _requiredLandmarks
              .where((type) => pose.landmarks[type] != null)
              .length;

          if (detectedCount < 8) {
            widget.onResult(0, 'Step back to show full body');
            _speakMyanmar('Step back to show full body');
            _isProcessing = false;
            return;
          }

          final angles = _calculateAnglesFromPose(pose);
          final result = _compareWithReference(angles);
          widget.onResult(result.$1, result.$2);

          if (result.$1 >= 90) {
            _speakMyanmar('Excellent alignment!');
          } else if (result.$1 >= 0 && result.$2.isNotEmpty) {
            _speakMyanmar(result.$2);
          }
        } else if (mounted) {
          widget.onResult(0, 'No person detected');
          _speakMyanmar('Match the reference pose');
        }
      } catch (_) {}

      _isProcessing = false;
    });
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

  Map<String, double> _calculateAnglesFromPose(Pose pose) {
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
    };

    for (final entry in mapping.entries) {
      final landmark = pose.landmarks[entry.key];
      if (landmark != null) {
        lm[entry.value] = [landmark.x, landmark.y];
      }
    }

    final angles = <String, double>{};

    if (lm['leftShoulder'] != null &&
        lm['leftElbow'] != null &&
        lm['leftHip'] != null) {
      angles['leftElbowAngle'] = _calcAngle(
          lm['leftShoulder']!, lm['leftElbow']!, lm['leftHip']!);
    }
    if (lm['rightShoulder'] != null &&
        lm['rightElbow'] != null &&
        lm['rightHip'] != null) {
      angles['rightElbowAngle'] = _calcAngle(
          lm['rightShoulder']!, lm['rightElbow']!, lm['rightHip']!);
    }
    if (lm['leftHip'] != null &&
        lm['leftKnee'] != null &&
        lm['leftAnkle'] != null) {
      angles['leftKneeAngle'] =
          _calcAngle(lm['leftHip']!, lm['leftKnee']!, lm['leftAnkle']!);
    }
    if (lm['rightHip'] != null &&
        lm['rightKnee'] != null &&
        lm['rightAnkle'] != null) {
      angles['rightKneeAngle'] =
          _calcAngle(lm['rightHip']!, lm['rightKnee']!, lm['rightAnkle']!);
    }
    if (lm['leftShoulder'] != null &&
        lm['rightShoulder'] != null &&
        lm['leftHip'] != null &&
        lm['rightHip'] != null) {
      final sc = [
        (lm['leftShoulder']![0] + lm['rightShoulder']![0]) / 2,
        (lm['leftShoulder']![1] + lm['rightShoulder']![1]) / 2,
      ];
      final hc = [
        (lm['leftHip']![0] + lm['rightHip']![0]) / 2,
        (lm['leftHip']![1] + lm['rightHip']![1]) / 2,
      ];
      angles['bodyTilt'] =
          _calcAngle([hc[0], hc[1] - 100], hc, sc);
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

  (double, String) _compareWithReference(Map<String, double> userAngles) {
    if (widget.stepAngles.isEmpty) return (0, 'No reference angles');

    double totalDiff = 0;
    int count = 0;

    for (final entry in widget.stepAngles.entries) {
      final userAngle = userAngles[entry.key];
      if (userAngle == null) continue;

      final diff = (entry.value - userAngle).abs();
      totalDiff += diff;
      count++;
    }

    if (count == 0) return (0, 'No matching angles');

    if (count < widget.stepAngles.length) {
      final matchRatio = count / widget.stepAngles.length;
      if (matchRatio < 0.6) {
        return (0, 'Not enough body visible');
      }
    }

    final avgDiff = totalDiff / count;
    final accuracy = max(0.0, 100 - (avgDiff / 45 * 100));

    String feedback;
    if (accuracy >= 90) {
      feedback = 'Excellent form!';
    } else if (accuracy >= 60) {
      feedback = 'Good, adjust slightly';
    } else if (accuracy >= 40) {
      feedback = 'Keep adjusting your pose';
    } else {
      feedback = 'Match the reference pose';
    }

    return (accuracy.roundToDouble(), feedback);
  }

  @override
  void dispose() {
    _cloudTts.stop();
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error.isNotEmpty) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text(
                _error,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return ClipRect(child: _cameraController!.buildPreview());
  }
}
