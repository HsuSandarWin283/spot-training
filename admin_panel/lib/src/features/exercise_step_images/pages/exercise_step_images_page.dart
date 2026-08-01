// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/models/exercise_step_image_model.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/exercise_step_images/providers/exercise_step_image_providers.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';

class ExerciseStepImagesPage extends ConsumerWidget {
  const ExerciseStepImagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(exerciseStepImagePostsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.exerciseStepImages,
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.exerciseStepImagesDescription,
                      style: const TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GradientButton(
                text: AppLocalizations.of(context)!.createPost,
                icon: Icons.add,
                onPressed: () {
                  ref.read(selectedExerciseStepImagePostProvider.notifier).state =
                      null;
                  ref.read(adminViewProvider.notifier).state =
                      AdminView.addExerciseStepImage;
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          postsAsync.when(
            data: (posts) {
              if (posts.isEmpty) {
                return EmptyState(
                  icon: Icons.photo_library_outlined,
                  title: AppLocalizations.of(context)!.noPostsYet,
                  subtitle: AppLocalizations.of(context)!.createFirstPost,
                );
              }
              return _buildPostsTable(context, ref, posts);
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: AdminColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTable(BuildContext context, WidgetRef ref, List<ExerciseStepImagePost> posts) {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(AppLocalizations.of(context)!.title)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.type)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.items)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.created)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.actions)),
                  ],
                  rows: posts.map((post) {
                    return DataRow(
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                color: AdminColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AdminColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              post.type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.photo_library_outlined,
                                  size: 16, color: AdminColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                '${post.itemCount} image${post.itemCount != 1 ? 's' : ''}',
                                style: const TextStyle(
                                  color: AdminColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                            style:
                                const TextStyle(color: AdminColors.textMuted),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: AdminColors.primary, size: 20),
                                onPressed: () {
                                  ref
                                      .read(selectedExerciseStepImagePostProvider
                                          .notifier)
                                      .state = post;
                                  ref.read(adminViewProvider.notifier).state =
                                      AdminView.editExerciseStepImage;
                                },
                                tooltip: 'View / Edit',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AdminColors.error, size: 20),
                                onPressed: () =>
                                    _confirmDelete(context, ref, post),
                                tooltip: AppLocalizations.of(context)!.delete,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, ExerciseStepImagePost post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletePost),
        content: Text(
            'Are you sure you want to delete "${post.title}" (${post.type}) with ${post.itemCount} image(s)? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(exerciseStepImageServiceProvider)
                    .deletePost(post.id);
                ref.invalidate(exerciseStepImageTypesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.postDeletedSuccessfully),
                      backgroundColor: AdminColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AdminColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: AdminColors.error)),
          ),
        ],
      ),
    );
  }
}
