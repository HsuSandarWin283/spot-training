// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/models/sport_detail_item.dart';
import 'package:ai_sports_training/src/core/constants/app_constants.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/sport_detail/providers/sport_detail_providers.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';

class SportDetailScreen extends ConsumerStatefulWidget {
  final String sportId;

  const SportDetailScreen({super.key, required this.sportId});

  @override
  ConsumerState<SportDetailScreen> createState() => _SportDetailScreenState();
}

class _SportDetailScreenState extends ConsumerState<SportDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<SportDetailType> _tabs = [
    SportDetailType.rules,
    SportDetailType.trainingMethods,
    SportDetailType.fitnessRequirements,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  SportData get _fallbackSport {
    try {
      return AppConstants.sports.firstWhere((s) => s.id == widget.sportId);
    } catch (_) {
      return SportData(
        id: widget.sportId,
        name: widget.sportId,
        icon: '🏅',
        color: 0xFF6C63FF,
        description: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sportAsync = ref.watch(sportInfoProvider(widget.sportId));
    final sportColor = Color(_fallbackSport.color);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg(context), AppColors.surf(context)],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(sportAsync, sportColor),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabs
                    .map((type) => _buildTabContent(widget.sportId, type))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      AsyncValue<Map<String, dynamic>?> sportAsync, Color sportColor) {
    final langCode = ref.watch(localeProvider).languageCode;
    return sportAsync.when(
      data: (sportData) {
        final nameEn = sportData?['nameEn'] as String? ?? '';
        final nameMm = sportData?['nameMm'] as String? ?? '';
        final descEn = sportData?['descriptionEn'] as String? ?? '';
        final descMm = sportData?['descriptionMm'] as String? ?? '';
        final name = langCode == 'my' && nameMm.isNotEmpty ? nameMm : (nameEn.isNotEmpty ? nameEn : _fallbackSport.name);
        final description = langCode == 'my' && descMm.isNotEmpty ? descMm : (descEn.isNotEmpty ? descEn : _fallbackSport.description);
        final thumbnailUrl = sportData?['thumbnailUrl'] ?? '';
        final icon = _fallbackSport.icon;

        return _buildHeaderContent(
          name: name,
          description: description,
          imageUrl: thumbnailUrl,
          icon: icon,
          sportColor: sportColor,
        );
      },
      loading: () {
        final langCode = ref.read(localeProvider).languageCode;
        return _buildHeaderContent(
          name: _fallbackSport.localizedName(langCode),
          description: _fallbackSport.localizedDescription(langCode),
          imageUrl: '',
          icon: _fallbackSport.icon,
          sportColor: sportColor,
        );
      },
      error: (_, __) {
        final langCode = ref.read(localeProvider).languageCode;
        return _buildHeaderContent(
          name: _fallbackSport.localizedName(langCode),
          description: _fallbackSport.localizedDescription(langCode),
          imageUrl: '',
          icon: _fallbackSport.icon,
          sportColor: sportColor,
        );
      },
    );
  }

  Widget _buildHeaderContent({
    required String name,
    required String description,
    required String imageUrl,
    required String icon,
    required Color sportColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [sportColor.withOpacity(0.4), AppColors.background],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 48,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_back_ios_new, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Text(
                        name,
                        style: TextStyle(
                          color: AppColors.txtPrimary(context),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              if (imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _buildSportIcon(icon, sportColor),
                  ),
                )
              else
                _buildSportIcon(icon, sportColor),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  color: AppColors.txtPrimary(context),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.txtSecondary(context),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportIcon(String icon, Color sportColor) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: sportColor.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: sportColor.withOpacity(0.4), width: 2),
      ),
      child: Center(
        child: Text(icon, style: TextStyle(fontSize: 32)),
      ),
    );
  }

  Widget _buildTabBar() {
    final langCode = ref.watch(localeProvider).languageCode;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surf(context),
        border: Border(top: BorderSide(color: AppColors.bdr(context), width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.txtMuted(context),
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: _tabs
            .map((type) => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_tabIcon(type), size: 16),
                      const SizedBox(width: 6),
                      Text(type.labelFor(langCode)),
                    ],
                  ),
                ))
            .toList(),
      ),
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

  Color _typeColor(SportDetailType type) {
    switch (type) {
      case SportDetailType.rules:
        return AppColors.primary;
      case SportDetailType.trainingMethods:
        return AppColors.secondary;
      case SportDetailType.injuryPreventions:
        return AppColors.error;
      case SportDetailType.fitnessRequirements:
        return AppColors.warning;
    }
  }

  Widget _buildTabContent(String sportId, SportDetailType type) {
    final itemsAsync = ref.watch(sportDetailListProvider((sportId, type)));

    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return _buildEmptyState(type);
        }
        return _buildDetailList(items, type);
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, _) => _buildErrorState(error),
    );
  }

  Widget _buildDetailList(List<SportDetailItem> items, SportDetailType type) {
    final langCode = ref.watch(localeProvider).languageCode;
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
                type.labelFor(langCode),
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

  Widget _buildItemCard(SportDetailItem item, SportDetailType type) {
    final color = _typeColor(type);
    final langCode = ref.watch(localeProvider).languageCode;

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

  Widget _buildEmptyState(SportDetailType type) {
    final langCode = ref.watch(localeProvider).languageCode;
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
              AppLocalizations.of(context)!.noTypeAvailable(type.labelFor(langCode)),
              style: TextStyle(
                color: AppColors.txtPrimary(context),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.sectionUpdatedSoon,
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
