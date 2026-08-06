// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';
import 'package:admin_panel/src/core/services/locale_provider.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';
import 'package:admin_panel/src/features/dashboard/pages/admin_dashboard_page.dart';
import 'package:admin_panel/src/features/sports_management/pages/sports_list_page.dart';
import 'package:admin_panel/src/features/sports_management/pages/sport_form_page.dart';
import 'package:admin_panel/src/features/sport_detail/pages/sport_detail_page.dart';
import 'package:admin_panel/src/features/sport_detail/pages/sport_detail_form_page.dart';
import 'package:admin_panel/src/features/sport_detail/providers/sport_detail_providers.dart';
import 'package:admin_panel/src/features/exercise_step_images/pages/exercise_step_images_page.dart';
import 'package:admin_panel/src/features/exercise_step_images/pages/exercise_step_image_form_page.dart';
import 'package:admin_panel/src/features/exercise_step_images/providers/exercise_step_image_providers.dart';
import 'package:admin_panel/src/features/user_management/pages/user_management_page.dart';
import 'package:admin_panel/src/features/auth/pages/admin_profile_page.dart';
import 'package:admin_panel/src/features/injury_management/pages/injury_management_page.dart';
import 'package:admin_panel/src/features/injury_management/pages/injury_form_page.dart';
import 'package:admin_panel/src/features/injury_management/providers/injury_providers.dart';

enum AdminView {
  dashboard,
  sports,
  addSport,
  editSport,
  sportDetail,
  addSportDetail,
  editSportDetail,
  exerciseStepImages,
  addExerciseStepImage,
  editExerciseStepImage,
  injuryManagement,
  addInjuryItem,
  editInjuryItem,
  users,
  adminProfile,
}

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
      case AdminView.sportDetail:
        return const SportDetailPage();
      case AdminView.addSportDetail:
        return const SportDetailFormPage();
      case AdminView.editSportDetail:
        final item = ref.watch(selectedSportDetailItemProvider);
        return SportDetailFormPage(
          detailType: null,
          item: item,
        );
      case AdminView.exerciseStepImages:
        return const ExerciseStepImagesPage();
      case AdminView.addExerciseStepImage:
        return const ExerciseStepImageFormPage();
      case AdminView.editExerciseStepImage:
        final post = ref.watch(selectedExerciseStepImagePostProvider);
        return ExerciseStepImageFormPage(post: post);
      case AdminView.injuryManagement:
        return const InjuryManagementPage();
      case AdminView.addInjuryItem:
        return const InjuryFormPage();
      case AdminView.editInjuryItem:
        final item = ref.watch(selectedInjuryItemProvider);
        return InjuryFormPage(item: item);
      case AdminView.users:
        return const UserManagementPage();
      case AdminView.adminProfile:
        return const AdminProfilePage();
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
            label: AppLocalizations.of(context)!.dashboard,
            isSelected: currentView == AdminView.dashboard,
          ),
          _buildNavItem(
            ref: ref,
            view: AdminView.sports,
            icon: Icons.sports_soccer,
            label: AppLocalizations.of(context)!.sportsManagement,
            isSelected: currentView == AdminView.sports,
          ),
          _buildNavItem(
            ref: ref,
            view: AdminView.exerciseStepImages,
            icon: Icons.photo_library_outlined,
            label: AppLocalizations.of(context)!.exerciseStepImages,
            isSelected: currentView == AdminView.exerciseStepImages,
          ),
          _buildNavItem(
            ref: ref,
            view: AdminView.injuryManagement,
            icon: Icons.health_and_safety,
            label: AppLocalizations.of(context)!.injuryPreventionAndTreatment,
            isSelected: currentView == AdminView.injuryManagement,
          ),
          _buildNavItem(
            ref: ref,
            view: AdminView.users,
            icon: Icons.people,
            label: AppLocalizations.of(context)!.users,
            isSelected: currentView == AdminView.users,
          ),
          _buildLanguageItem(context, ref),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.border),
            ),
            child: InkWell(
              onTap: () {
                ref.read(adminViewProvider.notifier).state = AdminView.adminProfile;
              },
              borderRadius: BorderRadius.circular(12),
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
                      Text(
                        AppLocalizations.of(context)!.admin,
                        style: const TextStyle(
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
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.confirmLogout),
                        content: Text(AppLocalizations.of(context)!.areYouSureSignOut),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text(AppLocalizations.of(context)!.signOut,
                                style: const TextStyle(color: AdminColors.error)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref.read(sportServiceProvider).signOut();
                    }
                  },
                  tooltip: AppLocalizations.of(context)!.signOut,
                ),
              ],
            ),
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
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AdminColors.textSecondary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final langLabel = currentLocale.languageCode == 'my' ? 'မြန်မာ' : 'English';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLanguageDialog(context, ref),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.language,
                  color: AdminColors.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  langLabel,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: const Text('English'),
              value: const Locale('en'),
              groupValue: currentLocale,
              onChanged: (locale) {
                if (locale != null) {
                  ref.read(localeProvider.notifier).setLocale(locale);
                }
                Navigator.of(ctx).pop();
              },
            ),
            RadioListTile<Locale>(
              title: const Text('မြန်မာ'),
              value: const Locale('my'),
              groupValue: currentLocale,
              onChanged: (locale) {
                if (locale != null) {
                  ref.read(localeProvider.notifier).setLocale(locale);
                }
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
