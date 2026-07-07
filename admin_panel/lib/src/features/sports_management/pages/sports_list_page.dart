// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/sports_management/providers/sports_provider.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';

class SportsListPage extends ConsumerWidget {
  const SportsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportsAsync = ref.watch(sportsListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sports Management',
                      style: TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage all sports and their training data',
                      style: TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GradientButton(
                text: 'Add Sport',
                icon: Icons.add,
                onPressed: () {
                  ref.read(adminViewProvider.notifier).state = AdminView.addSport;
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          sportsAsync.when(
            data: (sports) {
              if (sports.isEmpty) {
                return const EmptyState(
                  icon: Icons.sports_soccer_outlined,
                  title: 'No Sports Yet',
                  subtitle: 'Add your first sport to get started',
                );
              }
              return _buildSportsTable(context, ref, sports);
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

  Widget _buildSportsTable(
      BuildContext context, WidgetRef ref, List<SportModel> sports) {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Sport')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Difficulty')),
            DataColumn(label: Text('Created')),
            DataColumn(label: Text('Actions')),
          ],
          rows: sports.map((sport) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (sport.thumbnailUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            sport.thumbnailUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AdminColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.sports_soccer,
                                color: AdminColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AdminColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.sports_soccer,
                            color: AdminColors.primary,
                            size: 20,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Text(
                        sport.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AdminColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(
                      sport.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AdminColors.textSecondary),
                    ),
                  ),
                ),
                DataCell(DifficultyBadge(level: sport.difficultyLevel)),
                DataCell(
                  Text(
                    '${sport.createdAt.day}/${sport.createdAt.month}/${sport.createdAt.year}',
                    style: const TextStyle(color: AdminColors.textMuted),
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
                          ref.read(editingSportProvider.notifier).state = sport;
                          ref.read(adminViewProvider.notifier).state =
                              AdminView.editSport;
                        },
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AdminColors.error, size: 20),
                        onPressed: () =>
                            _confirmDelete(context, ref, sport),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, SportModel sport) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Sport'),
        content: Text('Are you sure you want to delete "${sport.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref.read(sportServiceProvider).deleteSport(sport.id);
                ref.invalidate(sportsListProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${sport.name} deleted successfully'),
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
            child: const Text('Delete',
                style: TextStyle(color: AdminColors.error)),
          ),
        ],
      ),
    );
  }
}
