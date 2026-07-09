// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/models/sport_detail_models.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/sport_detail/providers/sport_detail_providers.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';

class SportDetailPage extends ConsumerStatefulWidget {
  const SportDetailPage({super.key});

  @override
  ConsumerState<SportDetailPage> createState() => _SportDetailPageState();
}

class _SportDetailPageState extends ConsumerState<SportDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  final List<SportDetailType> _tabs = [
    SportDetailType.rules,
    SportDetailType.trainingMethods,
    SportDetailType.injuryPreventions,
    SportDetailType.fitnessRequirements,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(currentDetailTypeProvider.notifier).state =
            _tabs[_tabController.index];
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sportId = ref.watch(selectedSportIdProvider);
    final sportName = ref.watch(selectedSportNameProvider);
    final searchQuery = ref.watch(sportDetailSearchQueryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AdminColors.textPrimary, size: 20),
                onPressed: () {
                  _searchController.clear();
                  ref.read(sportDetailSearchQueryProvider.notifier).state = '';
                  ref.read(adminViewProvider.notifier).state = AdminView.sports;
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sportName,
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage sport details across all categories',
                      style: TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: AdminColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.border),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: AdminColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AdminColors.textMuted,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              tabs: _tabs
                  .map((type) => Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_tabIcon(type), size: 16),
                            const SizedBox(width: 6),
                            Text(type.label),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      ref.read(sportDetailSearchQueryProvider.notifier).state =
                          value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search,
                          color: AdminColors.textMuted, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: AdminColors.textMuted, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(sportDetailSearchQueryProvider
                                        .notifier)
                                    .state = '';
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GradientButton(
                text: 'Add',
                icon: Icons.add,
                onPressed: () {
                  ref.read(currentDetailTypeProvider.notifier).state =
                      _tabs[_tabController.index];
                  ref.read(selectedSportDetailItemProvider.notifier).state =
                      null;
                  ref.read(adminViewProvider.notifier).state =
                      AdminView.addSportDetail;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs
                .map((type) => _buildTabContent(sportId, type, searchQuery))
                .toList(),
          ),
        ),
      ],
    );
  }

  IconData _tabIcon(SportDetailType type) {
    switch (type) {
      case SportDetailType.rules:
        return Icons.gavel;
      case SportDetailType.trainingMethods:
        return Icons.fitness_center;
      case SportDetailType.injuryPreventions:
        return Icons.health_and_safety;
      case SportDetailType.fitnessRequirements:
        return Icons.directions_run;
    }
  }

  Widget _buildTabContent(
      String sportId, SportDetailType type, String searchQuery) {
    final itemsAsync = ref.watch(
      sportDetailListProvider((sportId, type)),
    );

    return itemsAsync.when(
      data: (items) {
        final filtered = searchQuery.isEmpty
            ? items
            : items
                .where((item) =>
                    item.title
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    item.description
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();

        if (filtered.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: EmptyState(
                    icon: _tabIcon(type),
                    title: 'No ${type.label} Yet',
                    subtitle:
                        'Add your first ${type.singularLabel.toLowerCase()} to get started',
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: AdminCard(
                  padding: EdgeInsets.zero,
                  child: _buildDataTable(context, ref, filtered, type),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error: $e',
          style: const TextStyle(color: AdminColors.error),
        ),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, WidgetRef ref,
      List<SportDetailItem> items, SportDetailType type) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Created Date')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: items.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AdminColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),
                          child: Text(
                            item.description,
                            style:
                                const TextStyle(color: AdminColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
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
                                    .read(
                                        currentDetailTypeProvider.notifier)
                                    .state = type;
                                ref
                                    .read(
                                        selectedSportDetailItemProvider.notifier)
                                    .state = item;
                                ref
                                    .read(adminViewProvider.notifier)
                                    .state = AdminView.editSportDetail;
                              },
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AdminColors.error, size: 20),
                              onPressed: () => _confirmDelete(
                                  context, ref, item, type),
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
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref,
      SportDetailItem item, SportDetailType type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${type.singularLabel}'),
        content: Text(
            'Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(sportDetailServiceProvider)
                    .deleteItem(item.id, type);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${type.singularLabel} deleted successfully'),
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
