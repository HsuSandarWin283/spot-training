// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/models/injury_item.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/injury_prevention/data/providers/injury_providers.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';

class InjuryPreventionScreen extends ConsumerStatefulWidget {
  const InjuryPreventionScreen({super.key});

  @override
  ConsumerState<InjuryPreventionScreen> createState() =>
      _InjuryPreventionScreenState();
}

class _InjuryPreventionScreenState extends ConsumerState<InjuryPreventionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<InjuryDataType> _tabs = [
    InjuryDataType.prevention,
    InjuryDataType.treatment,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bg(context),
                  AppColors.surf(context),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                CustomAppBar(title: AppLocalizations.of(context)!.injuryPreventionLabel, showBack: false),
                const SizedBox(height: 8),
                _buildTabBar(),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchInjuryHint,
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
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabs
                        .map((type) => _buildTabContent(type))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surf(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bdr(context)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.txtMuted(context),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: TextStyle(
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

  Widget _buildTabContent(InjuryDataType type) {
    final itemsAsync = ref.watch(injuryListProvider(type));
    final langCode = ref.read(localeProvider).languageCode;

    return itemsAsync.when(
      data: (items) {
        final filtered = _searchQuery.isEmpty
            ? items
            : items.where((item) {
                final title = item.localizedTitle(langCode).toLowerCase();
                final desc = item.localizedDescription(langCode).toLowerCase();
                final q = _searchQuery.toLowerCase();
                return title.contains(q) || desc.contains(q);
              }).toList();
        if (filtered.isEmpty) {
          return _buildEmptyState(type);
        }
        return _buildItemList(filtered, type);
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, _) => _buildErrorState(error),
    );
  }

  Widget _buildItemList(List<InjuryItem> items, InjuryDataType type) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _typeColor(type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_tabIcon(type),
                    color: _typeColor(type), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                _tabLabel(type),
                style: TextStyle(
                  color: AppColors.txtPrimary(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _buildItemCard(item, type),
              )),
        ],
      ),
    );
  }

  Widget _buildItemCard(InjuryItem item, InjuryDataType type) {
    final color = _typeColor(type);
    final langCode = ref.read(localeProvider).languageCode;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.localizedTitle(langCode),
                      style: TextStyle(
                        color: AppColors.txtPrimary(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.localizedDescription(langCode),
                      style: TextStyle(
                        color: AppColors.txtSecondary(context),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _typeColor(InjuryDataType type) {
    switch (type) {
      case InjuryDataType.prevention:
        return AppColors.secondary;
      case InjuryDataType.treatment:
        return AppColors.error;
    }
  }

  Widget _buildEmptyState(InjuryDataType type) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
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
                _tabIcon(type),
                size: 48,
                color: AppColors.txtMuted(context),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty
                  ? AppLocalizations.of(context)!.noResults
                  : _emptyTitle(type),
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
                  : AppLocalizations.of(context)!.sectionUpdatedSoon,
              style: TextStyle(
                color: AppColors.txtMuted(context),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
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
              AppLocalizations.of(context)!.failedToLoadData,
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
      ),
    );
  }
}
