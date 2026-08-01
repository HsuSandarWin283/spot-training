// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/providers/fitness_assessment_providers.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/fitness_assessment.dart';
import 'package:ai_sports_training/src/features/exercise_progress/data/providers/exercise_progress_providers.dart';
import 'package:ai_sports_training/src/features/exercise_progress/data/models/goal_progress.dart';

class DashboardScreen extends ConsumerWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onAnalysisTap;
  const DashboardScreen({super.key, this.onProfileTap, this.onAnalysisTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userProfile = ref.watch(userProfileStreamProvider);
    final assessmentAsync = ref.watch(latestAssessmentProvider);
    final goalsAsync = ref.watch(goalProgressListProvider);
    final recommendationsAsync = ref.watch(exerciseRecommendationsProvider);

    final displayName =
        userProfile.whenOrNull(data: (u) => u?.fullName) ??
            user?.fullName ??
            'Athlete';

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
                _buildHeader(context, displayName, user),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFitnessLevelCard(context, assessmentAsync),
                        const SizedBox(height: 20),
                        _buildGoalProgressSection(context, goalsAsync),
                        const SizedBox(height: 20),
                        _buildFeedbackSection(context, goalsAsync),
                        const SizedBox(height: 20),
                        _buildRecommendationsSection(
                            context, recommendationsAsync),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildHeader(
      BuildContext context, String displayName, dynamic user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()}! 👋',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                displayName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (displayName.isNotEmpty ? displayName[0] : 'A')
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Fitness Level Card ──

  Widget _buildFitnessLevelCard(
      BuildContext context, AsyncValue<FitnessAssessment?> assessmentAsync) {
    return assessmentAsync.when(
      loading: () => const GlassCard(
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: AppColors.primary),
        )),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (assessment) {
        final level = assessment?.fitnessLevel?.name ?? 'beginner';
        final score = assessment?.overallScore ?? 0;
        Color levelColor;
        IconData levelIcon;
        if (level == 'advanced') {
          levelColor = AppColors.success;
          levelIcon = Icons.military_tech;
        } else if (level == 'intermediate') {
          levelColor = AppColors.warning;
          levelIcon = Icons.trending_up;
        } else {
          levelColor = AppColors.primary;
          levelIcon = Icons.fitness_center;
        }

        return GlassCard(
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(levelColor),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      score.toStringAsFixed(0),
                      style: TextStyle(
                        color: levelColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fitness Level',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(levelIcon, color: levelColor, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          level[0].toUpperCase() + level.substring(1),
                          style: TextStyle(
                            color: levelColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assessment != null
                          ? 'Age ${assessment.age} • ${assessment.heightCm.toStringAsFixed(0)}cm • ${assessment.weightKg.toStringAsFixed(0)}kg'
                          : 'Complete your assessment',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Goal Progress Section (only completed goals) ──

  Widget _buildGoalProgressSection(
      BuildContext context, AsyncValue<List<GoalProgress>> goalsAsync) {
    return goalsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        if (goals.isEmpty) {
          return GlassCard(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports,
                      color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No Completed Exercises',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Complete exercises to see your progress here.',
                  style:
                      TextStyle(color: AppColors.textMuted, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
                title: 'Your Goals (${goals.length})'),
            const SizedBox(height: 12),
            ...goals.map((goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildGoalCard(goal),
                )),
          ],
        );
      },
    );
  }

  Widget _buildGoalCard(GoalProgress goal) {
    final accuracy = goal.averageAccuracy;
    Color accColor;
    if (accuracy >= 80) {
      accColor = AppColors.success;
    } else if (accuracy >= 50) {
      accColor = AppColors.warning;
    } else {
      accColor = AppColors.error;
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _getGoalEmoji(goal.goal),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.goal,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${goal.poses.length} exercise${goal.poses.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${goal.totalSuccesses}',
                    style: TextStyle(
                      color: accColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'sessions',
                    style:
                        TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Accuracy',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    AppProgressBar(
                      value: accuracy / 100,
                      color: accColor,
                      height: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${accuracy.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: accColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: goal.poses
                .map((p) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '${p.poseName} (${p.successCount}x)',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 11),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── Feedback Section (rule-based from success counts) ──

  Widget _buildFeedbackSection(
      BuildContext context, AsyncValue<List<GoalProgress>> goalsAsync) {
    return goalsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        if (goals.isEmpty) return const SizedBox.shrink();

        final strengths = <String>[];
        final improvements = <String>[];

        for (final goal in goals) {
          if (goal.totalSuccesses >= 15) {
            strengths.add('${goal.goal}: ${goal.feedback}');
          } else if (goal.totalSuccesses >= 5) {
            strengths.add('${goal.goal}: ${goal.feedback}');
          } else {
            improvements.add('${goal.goal}: ${goal.feedback}');
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Performance Feedback'),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (strengths.isNotEmpty) ...[
                    const Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColors.success, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Strengths',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...strengths.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $s',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13),
                          ),
                        )),
                  ],
                  if (improvements.isNotEmpty) ...[
                    if (strengths.isNotEmpty) const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(Icons.warning_amber,
                            color: AppColors.warning, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Needs Practice',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...improvements.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $s',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Recommendations Section ──

  Widget _buildRecommendationsSection(BuildContext context,
      AsyncValue<List<ExerciseProgressEntry>> recsAsync) {
    return recsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (recs) {
        if (recs.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Recommended Next'),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome,
                          color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Practice these exercises',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...recs.map((rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.fitness_center,
                                  color: AppColors.primary, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rec.poseName,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${rec.goal} • ${rec.successCount} completed',
                                    style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${rec.averageAccuracy.toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: rec.averageAccuracy >= 70
                                    ? AppColors.success
                                    : AppColors.warning,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _getGoalEmoji(String goal) {
    switch (goal.toLowerCase()) {
      case 'football':
        return '⚽';
      case 'basketball':
        return '🏀';
      case 'volleyball':
        return '🏐';
      case 'badminton':
        return '🏸';
      case 'weight loss':
        return '🔥';
      case 'yoga':
        return '🧘';
      case 'stretching':
        return '🤸';
      default:
        return '🏃';
    }
  }
}
