// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/providers/fitness_assessment_providers.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/fitness_assessment.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/data/providers/exercise_completion_providers.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/data/services/exercise_completion_service.dart';

class DashboardScreen extends ConsumerWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onAnalysisTap;
  const DashboardScreen({super.key, this.onProfileTap, this.onAnalysisTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userProfile = ref.watch(userProfileStreamProvider);
    final assessmentAsync = ref.watch(latestAssessmentProvider);
    final completionsAsync = ref.watch(completionsByTypeProvider);
    final completedAsync = ref.watch(completedExercisesProvider);
    final incompleteAsync = ref.watch(incompleteExercisesProvider);

    final displayName =
        userProfile.whenOrNull(data: (u) => u?.fullName) ??
            user?.fullName ??
            'Athlete';

    final photoUrl = userProfile.whenOrNull(data: (u) => u?.photoUrl) ?? user?.photoUrl;

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
            child: Column(
              children: [
                 _buildHeader(context, displayName, photoUrl),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                         _buildCompletedExercises(context, completedAsync),
                         const SizedBox(height: 20),
                         _buildIncompleteExercises(context, incompleteAsync),
                         const SizedBox(height: 20),
                          _buildTrainingInsight(context, completionsAsync, assessmentAsync),
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
      BuildContext context, String displayName, String? photoUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()}! 👋',
                style: TextStyle(
                    color: AppColors.txtMuted(context), fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                displayName,
                style: TextStyle(
                  color: AppColors.txtPrimary(context),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onProfileTap,
            child: photoUrl != null && photoUrl.isNotEmpty
                ? Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (displayName.isNotEmpty ? displayName[0] : 'A')
                            .toUpperCase(),
                        style: TextStyle(
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

  // ── Training Insight Section ──

  Widget _buildTrainingInsight(
      BuildContext context,
      AsyncValue<List<TypeCompletionCount>> completionsAsync,
      AsyncValue<FitnessAssessment?> assessmentAsync) {
    return completionsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (completions) {
        if (completions.isEmpty) {
          final l10n = AppLocalizations.of(context)!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: l10n.trainingInsight),
              const SizedBox(height: 12),
              GlassCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.fitness_center, size: 48, color: AppColors.primary),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noCompletedExercises,
                          style: TextStyle(color: AppColors.txtPrimary(context), fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.completeExercisesToSee,
                          style: TextStyle(color: AppColors.txtSecondary(context), fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        final topType = completions.first.typeName;
        final topCount = completions.first.count;
        final langCode = Localizations.localeOf(context).languageCode;
        final l10n = AppLocalizations.of(context)!;

        final typeLower = topType.toLowerCase();
        final emoji = _getGoalEmoji(topType);

        final recommendedSessions = topCount < 3 ? 3 : (topCount < 5 ? 4 : 5);

        final focusAreas = _getFocusAreas(typeLower, l10n);

        String? goalName;
        String? goalAdvice;

        final assessment = assessmentAsync.whenOrNull(data: (a) => a);
        if (assessment != null) {
          final bmi = assessment.weightKg /
              ((assessment.heightCm / 100) * (assessment.heightCm / 100));

          if (bmi > 25) {
            goalName = langCode == 'my' ? 'အလေးချိန် လျှော့ချခြင်း' : 'Weight Loss';
            goalAdvice = l10n.goalWeightLossAdvice(topType);
            if (!focusAreas.contains(l10n.focusCardio)) focusAreas.add(l10n.focusCardio);
            if (!focusAreas.contains(l10n.focusFullBody)) focusAreas.add(l10n.focusFullBody);
          } else if (bmi < 18.5) {
            goalName = langCode == 'my' ? 'အလေးချိန် တိုးခြင်း' : 'Weight Gain';
            goalAdvice = l10n.goalWeightGainAdvice(topType);
            if (!focusAreas.contains(l10n.focusUpperBodyStrength)) focusAreas.add(l10n.focusUpperBodyStrength);
            if (!focusAreas.contains(l10n.focusCoreStrength)) focusAreas.add(l10n.focusCoreStrength);
          } else {
            goalName = langCode == 'my' ? 'ယေဘုယျ ကျန်းမာရေး' : 'General Fitness';
            goalAdvice = l10n.goalGeneralFitnessAdvice;
          }
         }

        String? tip;
        if (typeLower.contains('weight loss') || typeLower.contains('weight_gain')) {
          tip = typeLower.contains('weight loss')
              ? l10n.weightLossTip
              : l10n.weightGainTip;
        } else if (typeLower.contains('football')) {
          tip = l10n.sportTipFootball;
        } else if (typeLower.contains('basketball')) {
          tip = l10n.sportTipBasketball;
        } else if (typeLower.contains('volleyball')) {
          tip = l10n.sportTipVolleyball;
        } else if (typeLower.contains('badminton')) {
          tip = l10n.sportTipBadminton;
        } else if (typeLower.contains('yoga')) {
          tip = l10n.sportTipYoga;
        } else if (typeLower.contains('stretching')) {
          tip = l10n.sportTipStretching;
        }

        final recommendation = l10n.practiceRecommendation(recommendedSessions, topType);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: l10n.trainingInsight),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(emoji, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                               topType,
                               style: TextStyle(
                                 color: AppColors.txtPrimary(context),
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             const SizedBox(height: 2),
                             Text(
                               l10n.mostExercisingType(topType),
                               style: TextStyle(
                                 color: AppColors.txtSecondary(context),
                                 fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.mainActivitySuggestion(topType),
                    style: TextStyle(
                      color: AppColors.txtMuted(context),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Container(
                  //   padding: const EdgeInsets.all(12),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.primary.withOpacity(0.08),
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Icon(Icons.fitness_center,
                  //               color: AppColors.primary, size: 16),
                  //           const SizedBox(width: 8),
                  //           Text(
                  //             l10n.recommendedTraining,
                  //             style: TextStyle(
                  //               color: AppColors.primary,
                  //               fontSize: 13,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 8),
                  //       Text(
                  //         l10n.trainSessionsPerWeek(recommendedSessions),
                  //         style: TextStyle(
                  //           color: AppColors.txtSecondary(context),
                  //           fontSize: 13,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 14),
                  Text(
                    l10n.focusAreas,
                    style: TextStyle(
                      color: AppColors.txtPrimary(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: focusAreas
                        .map((area) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.surf(context),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.bdr(context)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: AppColors.success, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    area,
                                    style: TextStyle(
                                      color: AppColors.txtSecondary(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  if (goalName != null && goalAdvice != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flag,
                                  color: AppColors.warning, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                l10n.yourGoalLabel(goalName),
                                style: TextStyle(
                                  color: AppColors.warning,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                          goalAdvice,
                             style: TextStyle(
                               color: AppColors.txtSecondary(context),
                               fontSize: 13,
                               height: 1.4,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                   if (tip != null) ...[
                     const SizedBox(height: 16),
                     Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: AppColors.primary.withOpacity(0.08),
                         borderRadius: BorderRadius.circular(10),
                         border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Icon(Icons.lightbulb_outline,
                                   color: AppColors.primary, size: 18),
                               const SizedBox(width: 8),
                               Text(
                                 l10n.recommendedTraining,
                                 style: TextStyle(
                                   color: AppColors.primary,
                                   fontSize: 13,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ],
                           ),
                           const SizedBox(height: 8),
                           Text(
                             recommendation,
                             style: TextStyle(
                               color: AppColors.txtSecondary(context),
                               fontSize: 13,
                               height: 1.5,
                             ),
                           ),
                           const SizedBox(height: 8),
                           Text(
                             tip,
                             style: TextStyle(
                               color: AppColors.txtSecondary(context),
                               fontSize: 13,
                               height: 1.5,
                               fontStyle: FontStyle.italic,
                             ),
                           ),
                         ],
                       ),
                     ),
                    ],
                  ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> _getFocusAreas(String typeLower, AppLocalizations l10n) {
    if (typeLower.contains('football')) {
      return [l10n.focusLowerBodyStrength, l10n.focusBalance, l10n.focusAgility, l10n.focusCoordination];
    } else if (typeLower.contains('basketball')) {
      return [l10n.focusUpperBodyStrength, l10n.focusAgility, l10n.focusCoordination, l10n.focusBalance];
    } else if (typeLower.contains('volleyball')) {
      return [l10n.focusUpperBodyStrength, l10n.focusAgility, l10n.focusCoordination, l10n.focusCoreStrength];
    } else if (typeLower.contains('badminton')) {
      return [l10n.focusAgility, l10n.focusCoordination, l10n.focusFlexibility, l10n.focusEndurance];
    } else if (typeLower.contains('yoga')) {
      return [l10n.focusFlexibility, l10n.focusBalance, l10n.focusCoreStrength, l10n.focusEndurance];
    } else if (typeLower.contains('stretching')) {
      return [l10n.focusFlexibility, l10n.focusBalance, l10n.focusEndurance];
    } else if (typeLower.contains('weight loss')) {
      return [l10n.focusCardio, l10n.focusFullBody, l10n.focusEndurance, l10n.focusCoreStrength];
    } else if (typeLower.contains('weight gain') || typeLower.contains('strength')) {
      return [l10n.focusUpperBodyStrength, l10n.focusLowerBodyStrength, l10n.focusCoreStrength, l10n.focusFullBody];
    } else {
      return [l10n.focusFullBody, l10n.focusCardio, l10n.focusCoreStrength, l10n.focusBalance];
    }
  }

  // ── Completed Exercises ──

  Widget _buildCompletedExercises(
      BuildContext context, AsyncValue<List<IncompleteExercise>> completedAsync) {
    return completedAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (completed) {
        final l10n = AppLocalizations.of(context)!;
        final langCode = Localizations.localeOf(context).languageCode;

        if (completed.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: l10n.exerciseCompletions),
              const SizedBox(height: 12),
              GlassCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          l10n.noCompletedExercisesYet,
                          style: TextStyle(color: AppColors.txtSecondary(context), fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: l10n.exerciseCompletions),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: completed.map((exercise) {
                  final displayCount = exercise.completedItems >= exercise.totalItems
                      ? exercise.totalItems
                      : exercise.completedItems;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.localizedTitle(langCode),
                                style: TextStyle(
                                  color: AppColors.txtPrimary(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.itemsCompletedCount(displayCount, exercise.totalItems),
                                style: TextStyle(
                                  color: AppColors.txtMuted(context),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            context.push('/exercise-step-pose/${exercise.postId}');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Text(
                              l10n.practiceAgain,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIncompleteExercises(
      BuildContext context, AsyncValue<List<IncompleteExercise>> incompleteAsync) {
    return incompleteAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (incomplete) {
        final l10n = AppLocalizations.of(context)!;
        final langCode = Localizations.localeOf(context).languageCode;

        if (incomplete.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: l10n.incompleteExercises),
              const SizedBox(height: 12),
              GlassCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, size: 48, color: AppColors.success),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noIncompleteExercises,
                          style: TextStyle(color: AppColors.txtSecondary(context), fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: l10n.incompleteExercises),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: incomplete.map((exercise) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.pending_outlined,
                              color: AppColors.warning,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.localizedTitle(langCode),
                                style: TextStyle(
                                  color: AppColors.txtPrimary(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                               const SizedBox(height: 4),
                               Text(
                                 l10n.itemsCompletedCount(exercise.completedItems, exercise.totalItems),
                                 style: TextStyle(
                                   color: AppColors.txtMuted(context),
                                   fontSize: 12,
                                 ),
                               ),
                               const SizedBox(height: 2),
                               Container(
                                 padding: EdgeInsets.symmetric(
                                     horizontal: 6, vertical: 2),
                                 decoration: BoxDecoration(
                                   color: AppColors.warning.withOpacity(0.15),
                                   borderRadius: BorderRadius.circular(6),
                                 ),
                                 child: Text(
                                   l10n.stillIncomplete,
                                   style: TextStyle(
                                     color: AppColors.warning,
                                     fontSize: 10,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),
                               ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            context.push('/exercise-step-pose/${exercise.postId}');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Text(
                              l10n.continueExercise,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

