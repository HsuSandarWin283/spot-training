// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/constants/app_constants.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:ai_sports_training/src/features/sport_detail/providers/sport_detail_providers.dart';

class SportsSelectionScreen extends ConsumerWidget {
  const SportsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportsAsync = ref.watch(sportsListProvider);

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
                CustomAppBar(title: AppLocalizations.of(context)!.selectYourSport, showBack: false),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppLocalizations.of(context)!.chooseSportDescription,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: sportsAsync.when(
                    data: (sports) {
                      if (sports.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: sports.length,
                        itemBuilder: (context, index) {
                          final sport = sports[index];
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sports_soccer_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.noSportsAvailable,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.sportsWillAppear,
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
            AppLocalizations.of(context)!.failedToLoadSports,
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
            color: AppColors.card,
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
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
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
        child: Text(widget.icon, style: const TextStyle(fontSize: 36)),
      ),
    );
  }
}
