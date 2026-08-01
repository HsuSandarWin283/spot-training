import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';

class AIRecommendationScreen extends StatelessWidget {
  const AIRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF151A30),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                CustomAppBar(title: AppLocalizations.of(context)!.aiRecommendation),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        GlassCard(
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Alex Johnson',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '22 years old  |  175 cm  |  72 kg',
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppLocalizations.of(context)!.fitnessLevelIntermediate,
                                      style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SectionHeader(title: AppLocalizations.of(context)!.analysisLabel),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GlassCard(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            height: 70,
                                            child: CircularProgressIndicator(
                                              value: 0.22,
                                              strokeWidth: 6,
                                              backgroundColor: AppColors.border,
                                              valueColor: const AlwaysStoppedAnimation<Color>(
                                                AppColors.secondary,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '22.7',
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!.bmi,
                                                style: const TextStyle(
                                                  color: AppColors.textMuted,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.normal,
                                        style: const TextStyle(
                                          color: AppColors.success,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GlassCard(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            height: 70,
                                            child: CircularProgressIndicator(
                                              value: 0.76,
                                              strokeWidth: 6,
                                              backgroundColor: AppColors.border,
                                              valueColor: const AlwaysStoppedAnimation<Color>(
                                                AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '76%',
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!.score,
                                                style: const TextStyle(
                                                  color: AppColors.textMuted,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Good',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SectionHeader(title: AppLocalizations.of(context)!.personalizedTrainingPlan),
                        const SizedBox(height: 12),
                        _buildPlanCard(
                          AppLocalizations.of(context)!.weeklyWorkoutPlan,
                          AppLocalizations.of(context)!.sessionsPerWeek,
                          Icons.calendar_today,
                          AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        _buildPlanCard(
                          AppLocalizations.of(context)!.exerciseRecommendations,
                          AppLocalizations.of(context)!.basedOnFitnessLevel,
                          Icons.fitness_center,
                          AppColors.secondary,
                        ),
                        const SizedBox(height: 12),
                        _buildPlanCard(
                          AppLocalizations.of(context)!.nutritionGuide,
                          AppLocalizations.of(context)!.customizedMealPlans,
                          Icons.restaurant,
                          AppColors.warning,
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          text: AppLocalizations.of(context)!.startTrainingPlan,
                          icon: Icons.play_arrow,
                          onPressed: () {
                            context.goToWeeklyPlan();
                          },
                        ),
                        const SizedBox(height: 20),
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

  Widget _buildPlanCard(String title, String subtitle, IconData icon, Color color) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
