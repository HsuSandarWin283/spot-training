import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise_category.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/providers/exercise_flow_providers.dart';
import 'package:ai_sports_training/src/features/exercise_flow/ui/pages/exercise_list_screen.dart';

class ExerciseCategoriesScreen extends ConsumerWidget {
  const ExerciseCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync =
        ref.watch(exerciseFlowServiceProvider).getCategories();

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
                const CustomAppBar(title: 'Exercise Categories', showBack: true),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Choose a category to start training',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: StreamBuilder<List<ExerciseCategory>>(
                    stream: categoriesAsync,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        );
                      }

                      final categories = snapshot.data ?? [];
                      if (categories.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return _CategoryCard(
                            category: cat,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ExerciseListScreen(
                                    categoryId: cat.id,
                                    categoryName: cat.name,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Categories Yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Exercise categories will appear here.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ExerciseCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'weight_loss':
        return Icons.local_fire_department;
      case 'strength':
        return Icons.fitness_center;
      case 'stretching':
        return Icons.accessibility_new;
      case 'football':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getIcon(category.iconName),
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.exerciseCount} exercises',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 22),
        ],
      ),
    );
  }
}
