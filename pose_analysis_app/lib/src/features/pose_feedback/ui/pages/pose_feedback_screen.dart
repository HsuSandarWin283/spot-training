// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
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
                const CustomAppBar(title: 'Pose Feedback'),
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
                                'Your Pose',
                                AppColors.primary,
                                Icons.person,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPoseComparison(
                                'Ideal Pose',
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
                              const Text(
                                'Accuracy',
                                style: TextStyle(
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
                                child: const Text(
                                  'Good Form',
                                  style: TextStyle(
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
                        const SectionHeader(title: 'Strengths'),
                        const SizedBox(height: 12),
                        _buildFeedbackItem(
                          '✅',
                          'Good back alignment during the movement',
                          AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        _buildFeedbackItem(
                          '✅',
                          'Proper knee tracking over toes',
                          AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        _buildFeedbackItem(
                          '✅',
                          'Consistent tempo throughout',
                          AppColors.success,
                        ),
                        const SizedBox(height: 20),
                        const SectionHeader(title: 'Areas to Improve'),
                        const SizedBox(height: 12),
                        _buildFeedbackItem(
                          '⚠️',
                          'Arm position could be more stable',
                          AppColors.warning,
                        ),
                        const SizedBox(height: 8),
                        _buildFeedbackItem(
                          '⚠️',
                          'Slightly forward lean at bottom',
                          AppColors.warning,
                        ),
                        const SizedBox(height: 20),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '💡 Improvement Suggestions',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildSuggestion(
                                'Keep your chest up throughout the movement',
                              ),
                              const SizedBox(height: 8),
                              _buildSuggestion(
                                'Focus on driving through your heels',
                              ),
                              const SizedBox(height: 8),
                              _buildSuggestion(
                                'Practice with a mirror to check form',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          text: 'Try Again',
                          icon: Icons.replay,
                          onPressed: () {
                            context.goToPoseAnalysis();
                          },
                        ),
                        const SizedBox(height: 12),
                        OutlineButton(
                          text: 'Back to Dashboard',
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
