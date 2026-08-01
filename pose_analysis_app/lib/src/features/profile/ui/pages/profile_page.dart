// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);

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
            child: userAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (_, __) => Center(child: Text(AppLocalizations.of(context)!.somethingWentWrong, style: TextStyle(color: AppColors.textMuted))),
              data: (user) => _buildContent(context, ref, user),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, User? user) {
    return Column(
      children: [
        CustomAppBar(title: AppLocalizations.of(context)!.profile, showBack: false),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    if (user?.photoUrl != null)
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 3),
                          image: DecorationImage(
                            image: NetworkImage(user!.photoUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            (user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'A').toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showEditProfileSheet(context, ref, user),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  user?.fullName ?? AppLocalizations.of(context)!.athlete,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                if (user != null && user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.bio!,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (user != null && user.phone != null && user.phone!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, color: AppColors.textMuted, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        user.phone!,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.intermediateLevel,
                    style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('22.7', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context)!.bmi, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('76%', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context)!.fitness, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('24', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context)!.sessions, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.person_outline, AppLocalizations.of(context)!.editProfile, AppColors.primary, () {
                        _showEditProfileSheet(context, ref, user);
                      }),
                      const Divider(color: AppColors.border),
                      _buildLanguageItem(context, ref),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: _buildMenuItem(Icons.logout, AppLocalizations.of(context)!.logout, AppColors.error, () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.card,
                        title: Text(AppLocalizations.of(context)!.logout, style: TextStyle(color: AppColors.textPrimary)),
                        content: Text(AppLocalizations.of(context)!.logoutConfirm, style: TextStyle(color: AppColors.textSecondary)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.textMuted)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text(AppLocalizations.of(context)!.logout, style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await ref.read(authRepositoryProvider).signOut();
                      if (context.mounted) context.go('/login');
                    }
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, User? user) {
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');
    final bioController = TextEditingController(text: user?.bio ?? '');
    final photoController = TextEditingController(text: user?.photoUrl ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.editProfile,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fullName,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phoneOptional,
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.bioOptional,
                  prefixIcon: const Icon(Icons.info_outline, color: AppColors.textMuted),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: photoController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profileImageUrlOptional,
                  prefixIcon: const Icon(Icons.link, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                text: AppLocalizations.of(context)!.saveChanges,
                icon: Icons.save,
                height: 50,
                onPressed: () async {
                  final newName = nameController.text.trim();
                  final newEmail = emailController.text.trim();
                  final newPhone = phoneController.text.trim();
                  final newBio = bioController.text.trim();
                  final newPhoto = photoController.text.trim();
                  if (newName.isNotEmpty) {
                    await ref.read(authRepositoryProvider).updateProfile(
                          fullName: newName,
                          email: newEmail.isNotEmpty ? newEmail : null,
                          photoUrl: newPhoto.isNotEmpty ? newPhoto : null,
                          phone: newPhone.isNotEmpty ? newPhone : null,
                          bio: newBio.isNotEmpty ? newBio : null,
                        );
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.profileUpdated),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final langLabel = currentLocale.languageCode == 'my' ? 'မြန်မာ' : 'English';

    return InkWell(
      onTap: () => _showLanguageDialog(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.language, color: AppColors.secondary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.settings, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                  Text(langLabel, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Language', style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: const Text('English', style: TextStyle(color: AppColors.textPrimary)),
              value: const Locale('en'),
              groupValue: currentLocale,
              activeColor: AppColors.primary,
              onChanged: (locale) {
                if (locale != null) ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.of(ctx).pop();
              },
            ),
            RadioListTile<Locale>(
              title: const Text('မြန်မာ', style: TextStyle(color: AppColors.textPrimary)),
              value: const Locale('my'),
              groupValue: currentLocale,
              activeColor: AppColors.primary,
              onChanged: (locale) {
                if (locale != null) ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
