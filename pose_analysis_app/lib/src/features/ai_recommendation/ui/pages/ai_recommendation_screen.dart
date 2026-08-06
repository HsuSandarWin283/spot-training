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
            decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.surface,
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
                                      style: TextStyle(
                                        color: AppColors.txtPrimary(context),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '22 years old  |  175 cm  |  72 kg',
                                      style: TextStyle(
                                        color: AppColors.txtMuted(context),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppLocalizations.of(context)!.fitnessLevelIntermediate,
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
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
                                padding: EdgeInsets.all(16),
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
                                              backgroundColor: AppColors.bdr(context),
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
                                                style: TextStyle(
                                                  color: AppColors.txtPrimary(context),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!.bmi,
                                                style: TextStyle(
                                                  color: AppColors.txtMuted(context),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.normal,
                                        style: TextStyle(
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
                                padding: EdgeInsets.all(16),
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
                                              backgroundColor: AppColors.bdr(context),
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
                                                style: TextStyle(
                                                  color: AppColors.txtPrimary(context),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!.score,
                                                style: TextStyle(
                                                  color: AppColors.txtMuted(context),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
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
                          context,
                          AppLocalizations.of(context)!.weeklyWorkoutPlan,
                          AppLocalizations.of(context)!.sessionsPerWeek,
                          Icons.calendar_today,
                          AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        _buildPlanCard(
                          context,
                          AppLocalizations.of(context)!.exerciseRecommendations,
                          AppLocalizations.of(context)!.basedOnFitnessLevel,
                          Icons.fitness_center,
                          AppColors.secondary,
                        ),
                        const SizedBox(height: 12),
                        _buildPlanCard(
                          context,
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

  Widget _buildPlanCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
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
                  style: TextStyle(
                    color: AppColors.txtPrimary(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.txtMuted(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.txtMuted(context)),
        ],
      ),
    );
  }
}
