// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/providers/exercise_step_image_providers.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';

class ExerciseStepPosesScreen extends ConsumerStatefulWidget {
  const ExerciseStepPosesScreen({super.key});

  @override
  ConsumerState<ExerciseStepPosesScreen> createState() =>
      _ExerciseStepPosesScreenState();
}

class _ExerciseStepPosesScreenState
    extends ConsumerState<ExerciseStepPosesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(exerciseStepImagePostsProvider);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: AppLocalizations.of(context)!.exerciseStepPoses, showBack: false),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppLocalizations.of(context)!.followStepByStepGuides,
                    style: TextStyle(
                      color: AppColors.txtSecondary(context).withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchPosesHint,
                      prefixIcon: Icon(Icons.search, color: AppColors.txtMuted(context), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: AppColors.txtMuted(context), size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                 Expanded(
                  child: postsAsync.when(
                    data: (posts) {
                      final langCode = ref.read(localeProvider).languageCode;
                      final filtered = _searchQuery.isEmpty
                          ? posts
                          : posts.where((p) {
                              final titleEn = p.titleEn.toLowerCase();
                              final titleMm = p.titleMm.toLowerCase();
                              final type = p.type.toLowerCase();
                              final q = _searchQuery.toLowerCase();
                              return titleEn.contains(q) || titleMm.contains(q) || type.contains(q);
                            }).toList();
                      if (filtered.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final post = filtered[index];
                          return _PostCard(
                            title: post.localizedTitle(langCode),
                            type: post.type,
                            itemCount: post.itemCount,
                            onTap: () {
                              context.goToExerciseStepPoseDetail(post.id);
                            },
                          );
                        },
                      );
                    },
                    loading: () => Center(
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
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.txtMuted(context).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: AppColors.txtMuted(context),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty
                ? AppLocalizations.of(context)!.noResults
                : AppLocalizations.of(context)!.noPosesAvailable,
            style: TextStyle(
              color: AppColors.txtPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? AppLocalizations.of(context)!.tryDifferentSearch
                : AppLocalizations.of(context)!.exerciseStepPosesWillAppear,
            style: TextStyle(
              color: AppColors.txtMuted(context),
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
            padding: EdgeInsets.all(20),
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
              color: AppColors.txtPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              color: AppColors.txtMuted(context),
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
          margin: EdgeInsets.only(bottom: 12),
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
                       style: TextStyle(
                         color: AppColors.txtPrimary(context),
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       ),
                       maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (widget.type.isNotEmpty) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.type,
                              style: TextStyle(
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
                          style: TextStyle(
                            color: AppColors.txtMuted(context),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.txtMuted(context),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
