// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/providers/exercise_step_image_providers.dart';

class ExerciseStepPosesScreen extends ConsumerWidget {
  const ExerciseStepPosesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(exerciseStepImagePostsProvider);

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
                CustomAppBar(title: AppLocalizations.of(context)!.exerciseStepPoses, showBack: false),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppLocalizations.of(context)!.followStepByStepGuides,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: postsAsync.when(
                    data: (posts) {
                      if (posts.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return _PostCard(
                            title: post.title,
                            type: post.type,
                            itemCount: post.itemCount,
                            onTap: () {
                              context.goToExerciseStepPoseDetail(post.id);
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    ),
                    error: (error, _) => _buildErrorState(context, error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
              Icons.photo_library_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.noPosesAvailable,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.exerciseStepPosesWillAppear,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.failedToLoadPoses,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final String title;
  final String type;
  final int itemCount;
  final VoidCallback onTap;

  const _PostCard({
    required this.title,
    required this.type,
    required this.itemCount,
    required this.onTap,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GlassCard(
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
                child: const Icon(
                  Icons.photo_library_outlined,
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
                      widget.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (widget.type.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.type,
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          AppLocalizations.of(context)!.stepsCount(widget.itemCount),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
