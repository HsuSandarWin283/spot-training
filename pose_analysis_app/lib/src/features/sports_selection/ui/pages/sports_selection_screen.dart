// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/constants/app_constants.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:ai_sports_training/src/features/sport_detail/providers/sport_detail_providers.dart';

class SportsSelectionScreen extends ConsumerStatefulWidget {
  const SportsSelectionScreen({super.key});

  @override
  ConsumerState<SportsSelectionScreen> createState() =>
      _SportsSelectionScreenState();
}

class _SportsSelectionScreenState extends ConsumerState<SportsSelectionScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sportsAsync = ref.watch(sportsListProvider);

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
                CustomAppBar(title: AppLocalizations.of(context)!.selectYourSport, showBack: false),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppLocalizations.of(context)!.chooseSportDescription,
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
                      hintText: AppLocalizations.of(context)!.searchSportsHint,
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
                  child: sportsAsync.when(
                    data: (sports) {
                      final filtered = _searchQuery.isEmpty
                          ? sports
                          : sports.where((s) {
                              final name = (s['name'] as String? ?? '').toLowerCase();
                              final desc = (s['description'] as String? ?? '').toLowerCase();
                              final q = _searchQuery.toLowerCase();
                              return name.contains(q) || desc.contains(q);
                            }).toList();
                      if (filtered.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final sport = filtered[index];
                          final sportId = sport['id'] as String;
                          final name = sport['name'] as String? ?? '';
                          final description =
                              sport['description'] as String? ?? '';
                          final imageUrl = sport['thumbnailUrl'] as String? ?? '';

                          final fallback = _findFallback(sportId);

                          return _SportCard(
                            name: name,
                            description: description,
                            imageUrl: imageUrl,
                            icon: fallback?['icon'] ?? '🏅',
                            colorValue: fallback?['color'] ?? 0xFF6C63FF,
                            onTap: () {
                              context.goToSportDetail(sportId);
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

  Map<String, dynamic>? _findFallback(String sportId) {
    for (final s in AppConstants.sports) {
      if (s.id == sportId) {
        return {'icon': s.icon, 'color': s.color};
      }
    }
    return null;
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
              Icons.sports_soccer_outlined,
              size: 48,
              color: AppColors.txtMuted(context),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty
                ? AppLocalizations.of(context)!.noResults
                : AppLocalizations.of(context)!.noSportsAvailable,
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
                : AppLocalizations.of(context)!.sportsWillAppear,
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
            AppLocalizations.of(context)!.failedToLoadSports,
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

class _SportCard extends StatefulWidget {
  final String name;
  final String description;
  final String imageUrl;
  final String icon;
  final int colorValue;
  final VoidCallback onTap;

  const _SportCard({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.colorValue,
    required this.onTap,
  });

  @override
  State<_SportCard> createState() => _SportCardState();
}

class _SportCardState extends State<_SportCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    final sportColor = Color(widget.colorValue);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.crd(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: sportColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: sportColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _buildIconFallback(sportColor),
                  ),
                )
              else
                _buildIconFallback(sportColor),
              const SizedBox(height: 14),
              Text(
                widget.name,
                style: TextStyle(
                  color: AppColors.txtPrimary(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.txtMuted(context),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconFallback(Color sportColor) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: sportColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(widget.icon, style: TextStyle(fontSize: 36)),
      ),
    );
  }
}
