// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';

class PoseFeedbackScreen extends StatelessWidget {
  const PoseFeedbackScreen({super.key});

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
                CustomAppBar(title: AppLocalizations.of(context)!.poseFeedback),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPoseComparison(
                                AppLocalizations.of(context)!.yourPose,
                                AppColors.primary,
                                Icons.person,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPoseComparison(
                                AppLocalizations.of(context)!.idealPose,
                                AppColors.secondary,
                                Icons.accessibility_new,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GlassCard(
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.accuracy,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '87%',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.goodForm,
                                  style: const TextStyle(
                                    color: AppColors.success,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SectionHeader(title: AppLocalizations.of(context)!.strengths),
                        const SizedBox(height: 12),
                        _buildFeedbackItem(
                          '✅',
                          AppLocalizations.of(context)!.feedbackBackAlignment,
                          AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        _buildFeedbackItem(
                          '✅',
                          AppLocalizations.of(context)!.feedbackKneeTracking,
                          AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        _buildFeedbackItem(
                          '✅',
                          AppLocalizations.of(context)!.feedbackTempo,
                          AppColors.success,
                        ),
                        const SizedBox(height: 20),
                        SectionHeader(title: AppLocalizations.of(context)!.areasToImprove),
                        const SizedBox(height: 12),
                        _buildFeedbackItem(
                          '⚠️',
                          AppLocalizations.of(context)!.feedbackArmStability,
                          AppColors.warning,
                        ),
                        const SizedBox(height: 8),
                        _buildFeedbackItem(
                          '⚠️',
                          AppLocalizations.of(context)!.feedbackForwardLean,
                          AppColors.warning,
                        ),
                        const SizedBox(height: 20),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '💡 ${AppLocalizations.of(context)!.improvementSuggestions}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildSuggestion(
                                AppLocalizations.of(context)!.suggestionChestUp,
                              ),
                              const SizedBox(height: 8),
                              _buildSuggestion(
                                AppLocalizations.of(context)!.suggestionHeels,
                              ),
                              const SizedBox(height: 8),
                              _buildSuggestion(
                                AppLocalizations.of(context)!.suggestionMirror,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          text: AppLocalizations.of(context)!.tryAgain,
                          icon: Icons.replay,
                          onPressed: () {
                            context.goToPoseAnalysis();
                          },
                        ),
                        const SizedBox(height: 12),
                        OutlineButton(
                          text: AppLocalizations.of(context)!.backToDashboard,
                          onPressed: () {
                            context.goToMain();
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

  Widget _buildPoseComparison(String label, Color color, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 50,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(String emoji, String text, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.arrow_right,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
