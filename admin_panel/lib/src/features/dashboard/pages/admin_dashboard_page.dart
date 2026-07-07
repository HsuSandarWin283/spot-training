import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';

final dashboardStatsProvider = FutureProvider<Map<String, int>>((ref) {
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
          const Text(
            'Dashboard',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Overview of your sports training platform',
            style: TextStyle(
              color: AdminColors.textSecondary.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          statsAsync.when(
            data: (stats) => _buildStatsGrid(stats),
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
          const Text(
            'Quick Actions',
            style: TextStyle(
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

  Widget _buildStatsGrid(Map<String, int> stats) {
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
              title: 'Total Sports',
              value: '${stats['totalSports'] ?? 0}',
              icon: Icons.sports_soccer,
              gradient: AdminColors.primaryGradient,
            ),
            StatCard(
              title: 'Training Poses',
              value: '${stats['totalPoses'] ?? 0}',
              icon: Icons.accessibility_new,
              gradient: AdminColors.successGradient,
            ),
            StatCard(
              title: 'Reference Images',
              value: '${stats['totalPoses'] ?? 0}',
              icon: Icons.image,
              gradient: AdminColors.warningGradient,
            ),
            StatCard(
              title: 'Registered Users',
              value: '${stats['totalUsers'] ?? 0}',
              icon: Icons.people,
              gradient: AdminColors.errorGradient,
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
          title: 'Add New Sport',
          subtitle: 'Create a new sport entry',
          color: AdminColors.primary,
          onTap: () {
            ref.read(adminViewProvider.notifier).state = AdminView.addSport;
          },
        ),
        _QuickActionCard(
          icon: Icons.list_alt,
          title: 'Manage Sports',
          subtitle: 'View and edit all sports',
          color: AdminColors.secondary,
          onTap: () {
            ref.read(adminViewProvider.notifier).state = AdminView.sports;
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
