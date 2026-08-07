// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/features/exercise_step_images/providers/exercise_step_image_providers.dart';

final dashboardStatsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(sportServiceProvider).getDashboardStats();
});

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.dashboard,
            style: const TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.overviewDescription,
            style: TextStyle(
              color: AdminColors.textSecondary.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          statsAsync.when(
            data: (stats) => _buildStatsGrid(context, stats),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                'Error loading stats: $e',
                style: const TextStyle(color: AdminColors.error),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context)!.quickActions,
            style: const TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, Map<String, int> stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
          children: [
            StatCard(
              title: AppLocalizations.of(context)!.totalSports,
              value: '${stats['totalSports'] ?? 0}',
              icon: Icons.sports_soccer,
              gradient: AdminColors.primaryGradient,
            ),
            StatCard(
              title: AppLocalizations.of(context)!.injuryPreventionCount,
              value: '${stats['totalInjuryPreventions'] ?? 0}',
              icon: Icons.health_and_safety,
              gradient: AdminColors.warningGradient,
            ),
            StatCard(
              title: AppLocalizations.of(context)!.injuryTreatmentCount,
              value: '${stats['totalInjuryTreatments'] ?? 0}',
              icon: Icons.medical_services,
              gradient: AdminColors.errorGradient,
            ),
            StatCard(
              title: AppLocalizations.of(context)!.exerciseStepPoses,
              value: '${stats['totalExerciseStepImages'] ?? 0}',
              icon: Icons.photo_library_outlined,
              gradient: AdminColors.primaryGradient,
            ),
            StatCard(
              title: AppLocalizations.of(context)!.registeredUsers,
              value: '${stats['totalUsers'] ?? 0}',
              icon: Icons.people,
              gradient: AdminColors.successGradient,
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _QuickActionCard(
          icon: Icons.add_circle_outline,
          title: AppLocalizations.of(context)!.addNewSport,
          subtitle: AppLocalizations.of(context)!.createNewSportEntry,
          color: AdminColors.primary,
          onTap: () {
            ref.read(adminViewProvider.notifier).state = AdminView.addSport;
          },
        ),
        _QuickActionCard(
          icon: Icons.list_alt,
          title: AppLocalizations.of(context)!.manageSports,
          subtitle: AppLocalizations.of(context)!.viewAndEditAllSports,
          color: AdminColors.secondary,
          onTap: () {
            ref.read(adminViewProvider.notifier).state = AdminView.sports;
          },
        ),
        _QuickActionCard(
          icon: Icons.photo_library_outlined,
          title: AppLocalizations.of(context)!.exerciseStepImages,
          subtitle: AppLocalizations.of(context)!.manageStepImagePosts,
          color: AdminColors.warning,
          onTap: () {
            ref.read(adminViewProvider.notifier).state =
                AdminView.exerciseStepImages;
          },
        ),
        _QuickActionCard(
          icon: Icons.add_photo_alternate_outlined,
          title: AppLocalizations.of(context)!.createStepImage,
          subtitle: AppLocalizations.of(context)!.addNewExerciseStepImages,
          color: AdminColors.success,
          onTap: () {
            ref.read(selectedExerciseStepImagePostProvider.notifier).state =
                null;
            ref.read(adminViewProvider.notifier).state =
                AdminView.addExerciseStepImage;
          },
        ),
        _QuickActionCard(
          icon: Icons.health_and_safety,
          title: AppLocalizations.of(context)!.injuryPreventionAndTreatment,
          subtitle: AppLocalizations.of(context)!.manageInjuryDataDescription,
          color: AdminColors.info,
          onTap: () {
            ref.read(adminViewProvider.notifier).state =
                AdminView.injuryManagement;
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      onTap: onTap,
      child: SizedBox(
        width: 220,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AdminColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AdminColors.textMuted),
          ],
        ),
      ),
    );
  }
}
