import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/session_result.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/providers/exercise_flow_providers.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

class ExerciseCompletionScreen extends ConsumerStatefulWidget {
  final Exercise exercise;
  final double overallAccuracy;
  final Duration totalDuration;
  final int estimatedCalories;
  final List<StepResult> stepResults;

  const ExerciseCompletionScreen({
    super.key,
    required this.exercise,
    required this.overallAccuracy,
    required this.totalDuration,
    required this.estimatedCalories,
    required this.stepResults,
  });

  @override
  ConsumerState<ExerciseCompletionScreen> createState() =>
      _ExerciseCompletionScreenState();
}

class _ExerciseCompletionScreenState
    extends ConsumerState<ExerciseCompletionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final result = ExerciseSessionResult(
      userId: user.uid,
      exerciseId: widget.exercise.id,
      exerciseName: widget.exercise.name,
      categoryId: widget.exercise.categoryId,
      stepResults: widget.stepResults,
      overallAccuracy: widget.overallAccuracy,
      totalDuration: widget.totalDuration,
      estimatedCalories: widget.estimatedCalories,
      completedAt: DateTime.now(),
    );

    await ref.read(exerciseFlowServiceProvider).saveSessionResult(result);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = widget.totalDuration.inMinutes;
    final seconds = widget.totalDuration.inSeconds % 60;
    final timeStr = '${minutes}m ${seconds}s';

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.emoji_events,
                            size: 64, color: AppColors.success),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Exercise Completed!',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.exercise.name,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildStatsRow(timeStr),
                    const SizedBox(height: 20),
                    _buildStepResults(),
                    const SizedBox(height: 32),
                    GradientButton(
                      text: 'Done',
                      icon: Icons.check,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlineButton(
                      text: 'Practice Again',
                      onPressed: () {
                        Navigator.of(context).pop();
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

  Widget _buildStatsRow(String timeStr) {
    return Row(
      children: [
        _buildStatCard(
          '${widget.overallAccuracy.toStringAsFixed(0)}%',
          'Accuracy',
          AppColors.success,
          Icons.speed,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          timeStr,
          'Duration',
          AppColors.primary,
          Icons.timer,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          '${widget.estimatedCalories}',
          'Calories',
          AppColors.warning,
          Icons.local_fire_department,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String value, String label, Color color, IconData icon) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepResults() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step Results',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.stepResults.map((result) {
            final color = result.accuracy >= 80
                ? AppColors.success
                : result.accuracy >= 50
                    ? AppColors.warning
                    : AppColors.error;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${result.stepNumber}',
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: result.accuracy / 100,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${result.accuracy.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
