// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';

class TrainingDetailsScreen extends StatefulWidget {
  const TrainingDetailsScreen({super.key});

  @override
  State<TrainingDetailsScreen> createState() => _TrainingDetailsScreenState();
}

class _TrainingDetailsScreenState extends State<TrainingDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _getDrills(BuildContext context) => [
    {
      'title': AppLocalizations.of(context)!.dribblingDrill,
      'description': AppLocalizations.of(context)!.dribblingDescription,
      'duration': '15 min',
      'difficulty': AppLocalizations.of(context)!.medium,
      'icon': '⚽',
      'color': AppColors.primary,
    },
    {
      'title': AppLocalizations.of(context)!.passingDrill,
      'description': AppLocalizations.of(context)!.passingDescription,
      'duration': '20 min',
      'difficulty': AppLocalizations.of(context)!.easy,
      'icon': '🔄',
      'color': AppColors.secondary,
    },
    {
      'title': AppLocalizations.of(context)!.shootingDrill,
      'description': AppLocalizations.of(context)!.shootingDescription,
      'duration': '25 min',
      'difficulty': AppLocalizations.of(context)!.hard,
      'icon': '🎯',
      'color': AppColors.warning,
    },
    {
      'title': AppLocalizations.of(context)!.smallSidedGame,
      'description': AppLocalizations.of(context)!.smallSidedDescription,
      'duration': '30 min',
      'difficulty': AppLocalizations.of(context)!.medium,
      'icon': '🏆',
      'color': AppColors.accent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF151A30),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const CustomAppBar(title: 'Training Details'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textMuted,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerHeight: 0,
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.beginner),
                      Tab(text: AppLocalizations.of(context)!.intermediate),
                      Tab(text: AppLocalizations.of(context)!.advanced),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDrillList(context),
                      _buildDrillList(context),
                      _buildDrillList(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrillList(BuildContext context) {
    final drills = _getDrills(context);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: drills.length,
      itemBuilder: (context, index) {
        final drill = drills[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: drill['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      drill['icon'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drill['title'],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        drill['description'],
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildChip(
                            Icons.access_time,
                            drill['duration'],
                            AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          _buildChip(
                            Icons.signal_cellular_alt,
                            drill['difficulty'],
                            drill['color'],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
