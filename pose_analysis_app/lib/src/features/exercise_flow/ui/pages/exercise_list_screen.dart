import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/providers/exercise_flow_providers.dart';
import 'package:ai_sports_training/src/features/exercise_flow/ui/pages/exercise_flow_screen.dart';

class ExerciseListScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const ExerciseListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref
        .watch(exerciseFlowServiceProvider)
        .getExercisesByCategory(categoryId);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: categoryName, showBack: true),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppLocalizations.of(context)!.selectExerciseToBegin,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: StreamBuilder<List<Exercise>>(
                    stream: exercisesAsync,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        );
                      }

                      final exercises = snapshot.data ?? [];
                      if (exercises.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.fitness_center,
                                  size: 48, color: AppColors.textMuted),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.noExercises,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return _ExerciseCard(
                            exercise: exercise,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ExerciseFlowScreen(
                                    exercise: exercise,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseCard({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (exercise.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                exercise.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.fitness_center,
                      color: AppColors.primary),
                ),
              ),
            )
          else
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fitness_center,
                  color: AppColors.primary, size: 28),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.stepsCount(exercise.stepCount),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill,
              color: AppColors.primary, size: 28),
        ],
      ),
    );
  }
}
