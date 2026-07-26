import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise_step.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/session_result.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/services/pose_analysis_service.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/services/exercise_flow_service.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/services/voice_coaching_service.dart';

final exerciseFlowServiceProvider = Provider<ExerciseFlowService>((ref) {
  return ExerciseFlowService();
});

final poseAnalysisServiceProvider = Provider<PoseAnalysisService>((ref) {
  return PoseAnalysisService();
});

final voiceCoachingServiceProvider = Provider<VoiceCoachingService>((ref) {
  return VoiceCoachingService();
});

class StepController extends StateNotifier<ExerciseStepState> {
  final List<ExerciseStep> steps;
  int _currentStepIndex = 0;
  int _totalAttempts = 1;
  DateTime? _stepStartTime;
  DateTime? _exerciseStartTime;
  bool _isCompleted = false;
  final List<StepResult> _stepResults = [];

  StepController(this.steps) : super(ExerciseStepState.initial()) {
    _exerciseStartTime = DateTime.now();
    _stepStartTime = DateTime.now();
    _updateState();
  }

  ExerciseStep get currentStep => steps[_currentStepIndex];
  bool get isLastStep => _currentStepIndex >= steps.length - 1;
  List<StepResult> get stepResults => List.unmodifiable(_stepResults);

  void _updateState() {
    state = ExerciseStepState(
      currentStepIndex: _currentStepIndex,
      totalSteps: steps.length,
      currentStep: currentStep,
      isStepComplete: false,
      accuracy: 0,
      angleDifferences: {},
      isAutoNext: currentStep.autoNext,
      isLastStep: isLastStep,
      stepResults: _stepResults,
    );
  }

  void onStepSuccess(double accuracy, Map<String, double> angleDiffs) {
    final duration = _stepStartTime != null
        ? DateTime.now().difference(_stepStartTime!)
        : Duration.zero;

    _stepResults.add(StepResult(
      stepNumber: currentStep.stepNumber,
      accuracy: accuracy,
      angleDifferences: angleDiffs,
      duration: duration,
      attemptCount: _totalAttempts,
    ));

    state = state.copyWith(
      isStepComplete: true,
      accuracy: accuracy,
      angleDifferences: angleDiffs,
    );

    _totalAttempts = 1;
  }

  void nextStep() {
    if (_isCompleted) return;

    _currentStepIndex++;
    _totalAttempts = 1;
    _stepStartTime = DateTime.now();

    if (_currentStepIndex >= steps.length) {
      _isCompleted = true;
      state = state.copyWith(isExerciseComplete: true);
    } else {
      _updateState();
    }
  }

  void incrementAttempt() {
    _totalAttempts++;
  }

  Duration get totalElapsed =>
      _exerciseStartTime != null
          ? DateTime.now().difference(_exerciseStartTime!)
          : Duration.zero;

  double get overallAccuracy {
    if (_stepResults.isEmpty) return 0;
    return _stepResults.fold<double>(0, (acc, r) => acc + r.accuracy) /
        _stepResults.length;
  }

  int get estimatedCalories {
    final minutes = totalElapsed.inMinutes;
    return (minutes * 8).clamp(0, 999);
  }
}

class ExerciseStepState {
  final int currentStepIndex;
  final int totalSteps;
  final ExerciseStep? currentStep;
  final bool isStepComplete;
  final double accuracy;
  final Map<String, double> angleDifferences;
  final bool isAutoNext;
  final bool isLastStep;
  final List<StepResult> stepResults;
  final bool isExerciseComplete;

  ExerciseStepState({
    required this.currentStepIndex,
    required this.totalSteps,
    this.currentStep,
    this.isStepComplete = false,
    this.accuracy = 0,
    this.angleDifferences = const {},
    this.isAutoNext = true,
    this.isLastStep = false,
    this.stepResults = const [],
    this.isExerciseComplete = false,
  });

  factory ExerciseStepState.initial() => ExerciseStepState(
        currentStepIndex: 0,
        totalSteps: 0,
      );

  ExerciseStepState copyWith({
    int? currentStepIndex,
    int? totalSteps,
    ExerciseStep? currentStep,
    bool? isStepComplete,
    double? accuracy,
    Map<String, double>? angleDifferences,
    bool? isAutoNext,
    bool? isLastStep,
    List<StepResult>? stepResults,
    bool? isExerciseComplete,
  }) {
    return ExerciseStepState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      totalSteps: totalSteps ?? this.totalSteps,
      currentStep: currentStep ?? this.currentStep,
      isStepComplete: isStepComplete ?? this.isStepComplete,
      accuracy: accuracy ?? this.accuracy,
      angleDifferences: angleDifferences ?? this.angleDifferences,
      isAutoNext: isAutoNext ?? this.isAutoNext,
      isLastStep: isLastStep ?? this.isLastStep,
      stepResults: stepResults ?? this.stepResults,
      isExerciseComplete: isExerciseComplete ?? this.isExerciseComplete,
    );
  }
}

final stepControllerProvider = StateNotifierProvider.autoDispose
    .family<StepController, ExerciseStepState, List<ExerciseStep>>(
  (ref, steps) => StepController(steps),
);
