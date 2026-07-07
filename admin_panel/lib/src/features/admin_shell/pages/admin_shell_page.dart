// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';
import 'package:admin_panel/src/features/dashboard/pages/admin_dashboard_page.dart';
import 'package:admin_panel/src/features/sports_management/pages/sports_list_page.dart';
import 'package:admin_panel/src/features/sports_management/pages/sport_form_page.dart';

enum AdminView { dashboard, sports, addSport, editSport }

final adminViewProvider = StateProvider<AdminView>((ref) => AdminView.dashboard);
final editingSportProvider = StateProvider<SportModel?>((ref) => null);

class AdminShellPage extends ConsumerWidget {
  const AdminShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentView = ref.watch(adminViewProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context, ref, currentView, user?.email ?? 'Admin'),
          Expanded(
            child: Container(
              color: AdminColors.background,
              child: _buildContent(ref, currentView),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(WidgetRef ref, AdminView view) {
    switch (view) {
      case AdminView.dashboard:
        return const AdminDashboardPage();
      case AdminView.sports:
        return const SportsListPage();
      case AdminView.addSport:
        return const SportFormPage();
      case AdminView.editSport:
        final sport = ref.watch(editingSportProvider);
        return SportFormPage(sport: sport);
    }
  }

  Widget _buildSidebar(
      BuildContext context, WidgetRef ref, AdminView currentView, String email) {
    return Container(
      width: 260,
      color: AdminColors.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AdminColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: AdminColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'AI Sports Training',
                        style: TextStyle(
                          color: AdminColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AdminColors.border, height: 1),
          const SizedBox(height: 16),
          _buildNavItem(
            ref: ref,
            view: AdminView.dashboard,
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isSelected: currentView == AdminView.dashboard,
          ),
          _buildNavItem(
            ref: ref,
            view: AdminView.sports,
            icon: Icons.sports_soccer,
            label: 'Sports Management',
            isSelected: currentView == AdminView.sports,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AdminColors.primary.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: AdminColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Admin',
                        style: TextStyle(
                          color: AdminColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          color: AdminColors.textMuted,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout,
                      color: AdminColors.textMuted, size: 18),
                  onPressed: () async {
                    await ref.read(sportServiceProvider).signOut();
                  },
                  tooltip: 'Sign Out',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required WidgetRef ref,
    required AdminView view,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ref.read(adminViewProvider.notifier).state = view,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: isSelected
                ? BoxDecoration(
                    gradient: AdminColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : AdminColors.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AdminColors.textSecondary,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
