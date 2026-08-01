// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/constants/app_constants.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';

class WeeklyPlanScreen extends StatelessWidget {
  const WeeklyPlanScreen({super.key});

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
                CustomAppBar(title: AppLocalizations.of(context)!.weeklyPlan),
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
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.weekOf(4, 1),
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      AppLocalizations.of(context)!.sessionsCompleted(5),
                                      style: TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '71%',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                           child: AppProgressBar(value: 0.71, height: 6),
                        ),
                        const SizedBox(height: 24),
                        ...AppConstants.weeklyPlan.asMap().entries.map((entry) {
                          final index = entry.key;
                          final day = entry.value;
                          final isCompleted = index < 5;
                          final isToday = index == 5;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _WeeklyDayCard(
                              day: day,
                              isCompleted: isCompleted,
                              isToday: isToday,
                            ),
                          );
                        }),
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
}

class _WeeklyDayCard extends StatelessWidget {
  final TrainingDay day;
  final bool isCompleted;
  final bool isToday;

  const _WeeklyDayCard({
    required this.day,
    required this.isCompleted,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final dayColor = Color(day.color);

    return GlassCard(
      borderColor: isToday
          ? dayColor.withOpacity(0.5)
          : AppColors.glassBorder,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success.withOpacity(0.15)
                  : dayColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 28,
                    )
                  : Text(
                      day.icon,
                      style: const TextStyle(fontSize: 26),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      day.day,
                      style: TextStyle(
                        color: isCompleted
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isToday) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: dayColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.today,
                          style: TextStyle(
                            color: dayColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  day.title,
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration:
                        isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  day.subtitle,
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.textMuted.withOpacity(0.6)
                        : AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isToday)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.of(context)!.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else if (!isCompleted)
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
