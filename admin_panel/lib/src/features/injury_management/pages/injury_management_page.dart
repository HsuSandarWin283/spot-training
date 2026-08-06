// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/models/injury_item.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/injury_management/providers/injury_providers.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';

class InjuryManagementPage extends ConsumerStatefulWidget {
  const InjuryManagementPage({super.key});

  @override
  ConsumerState<InjuryManagementPage> createState() =>
      _InjuryManagementPageState();
}

class _InjuryManagementPageState extends ConsumerState<InjuryManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  static const List<InjuryDataType> _tabs = [
    InjuryDataType.prevention,
    InjuryDataType.treatment,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(currentInjuryTypeProvider.notifier).state =
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
    final searchQuery = ref.watch(injurySearchQueryProvider);

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
                  ref.read(injurySearchQueryProvider.notifier).state = '';
                  ref.read(adminViewProvider.notifier).state =
                      AdminView.dashboard;
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.injuryPreventionAndTreatment,
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.manageInjuryDataDescription,
                      style: const TextStyle(
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
                            Text(_tabLabel(type)),
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
                      ref.read(injurySearchQueryProvider.notifier).state =
                          value;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
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
                                    .read(injurySearchQueryProvider.notifier)
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
                text: AppLocalizations.of(context)!.add,
                icon: Icons.add,
                onPressed: () {
                  ref.read(currentInjuryTypeProvider.notifier).state =
                      _tabs[_tabController.index];
                  ref.read(selectedInjuryItemProvider.notifier).state = null;
                  ref.read(adminViewProvider.notifier).state =
                      AdminView.addInjuryItem;
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
                .map((type) => _buildTabContent(type, searchQuery))
                .toList(),
          ),
        ),
      ],
    );
  }

  IconData _tabIcon(InjuryDataType type) {
    switch (type) {
      case InjuryDataType.prevention:
        return Icons.shield;
      case InjuryDataType.treatment:
        return Icons.healing;
    }
  }

  String _tabLabel(InjuryDataType type) {
    switch (type) {
      case InjuryDataType.prevention:
        return AppLocalizations.of(context)!.prevention;
      case InjuryDataType.treatment:
        return AppLocalizations.of(context)!.treatment;
    }
  }

  String _emptyTitle(InjuryDataType type) {
    switch (type) {
      case InjuryDataType.prevention:
        return AppLocalizations.of(context)!.noPreventionAvailable;
      case InjuryDataType.treatment:
        return AppLocalizations.of(context)!.noTreatmentAvailable;
    }
  }

  String _singularLabel(InjuryDataType type) {
    switch (type) {
      case InjuryDataType.prevention:
        return AppLocalizations.of(context)!.prevention;
      case InjuryDataType.treatment:
        return AppLocalizations.of(context)!.treatment;
    }
  }

  Widget _buildTabContent(InjuryDataType type, String searchQuery) {
    final itemsAsync = ref.watch(injuryListProvider(type));

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
                    title: _emptyTitle(type),
                    subtitle: AppLocalizations.of(context)!
                        .addFirstItem(_singularLabel(type).toLowerCase()),
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
      List<InjuryItem> items, InjuryDataType type) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text(AppLocalizations.of(context)!.title)),
                  DataColumn(
                      label:
                          Text(AppLocalizations.of(context)!.descriptionLabel)),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.createdDate)),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)!.actions)),
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
                            style: const TextStyle(
                                color: AdminColors.textSecondary),
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
                                    .read(currentInjuryTypeProvider.notifier)
                                    .state = type;
                                ref
                                    .read(selectedInjuryItemProvider.notifier)
                                    .state = item;
                                ref
                                    .read(adminViewProvider.notifier)
                                    .state = AdminView.editInjuryItem;
                              },
                              tooltip: AppLocalizations.of(context)!.edit,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AdminColors.error, size: 20),
                              onPressed: () =>
                                  _confirmDelete(context, ref, item, type),
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
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref,
      InjuryItem item, InjuryDataType type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.deleteType(_singularLabel(type))),
        content: Text(
            AppLocalizations.of(context)!.areYouSureDeleteItem(item.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref.read(injuryServiceProvider).deleteItem(item.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .typeDeletedSuccessfully(_singularLabel(type))),
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
