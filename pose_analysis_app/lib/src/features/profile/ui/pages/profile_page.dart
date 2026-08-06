// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';
import 'package:ai_sports_training/src/core/services/theme_provider.dart';
import 'package:ai_sports_training/src/core/services/image_upload_service.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/providers/fitness_assessment_providers.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/data/providers/exercise_completion_providers.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/ui/pages/fitness_assessment_screen.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);
    final assessmentAsync = ref.watch(latestAssessmentProvider);
    final completionsAsync = ref.watch(completionsByTypeProvider);

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
            child: userAsync.when(
              loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (_, __) => Center(child: Text(AppLocalizations.of(context)!.somethingWentWrong, style: TextStyle(color: AppColors.txtMuted(context)))),
              data: (user) => _buildContent(context, ref, user, assessmentAsync.valueOrNull, completionsAsync.valueOrNull),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, User? user, dynamic assessment, dynamic completions) {
    final hasAssessment = assessment != null;

    int totalCompletions = 0;
    if (completions != null) {
      for (final c in completions) {
        totalCompletions += (c.count as int);
      }
    }

    String fitnessLevel;
    if (totalCompletions >= 25) {
      fitnessLevel = 'advanced';
    } else if (totalCompletions >= 10) {
      fitnessLevel = 'intermediate';
    } else {
      fitnessLevel = 'beginner';
    }

    final bmi = hasAssessment
        ? (assessment.weightKg / ((assessment.heightCm / 100) * (assessment.heightCm / 100)))
        : 0.0;

    Color levelColor;
    if (fitnessLevel == 'advanced') {
      levelColor = AppColors.success;
    } else if (fitnessLevel == 'intermediate') {
      levelColor = AppColors.warning;
    } else {
      levelColor = AppColors.primary;
    }
    return Column(
      children: [
        CustomAppBar(title: AppLocalizations.of(context)!.profile, showBack: false),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                            style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showEditProfileSheet(context, ref, user),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
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
                  style: TextStyle(
                    color: AppColors.txtPrimary(context),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(color: AppColors.txtMuted(context), fontSize: 14),
                ),
                if (user != null && user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.bio!,
                    style: TextStyle(color: AppColors.txtSecondary(context), fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (user != null && user.phone != null && user.phone!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: AppColors.txtMuted(context), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        user.phone!,
                        style: TextStyle(color: AppColors.txtMuted(context), fontSize: 13),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                    child: Text(
                      fitnessLevel == 'advanced'
                          ? AppLocalizations.of(context)!.advancedLevel
                          : fitnessLevel == 'intermediate'
                              ? AppLocalizations.of(context)!.intermediateLevelLabel
                              : AppLocalizations.of(context)!.beginnerLevel,
                      style: TextStyle(color: levelColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (hasAssessment) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FitnessAssessmentScreen(
                            existingAssessment: assessment,
                          ),
                        ),
                      );
                    }
                  },
                  child: GlassCard(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                value: hasAssessment ? (assessment.overallScore ?? 0) / 100 : 0,
                                strokeWidth: 7,
                                backgroundColor: AppColors.bdr(context),
                                valueColor: AlwaysStoppedAnimation(levelColor),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Text(
                              hasAssessment ? (assessment.overallScore ?? 0).toStringAsFixed(0) : '0',
                              style: TextStyle(
                                color: levelColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasAssessment ? AppLocalizations.of(context)!.fitnessScoreLabel : AppLocalizations.of(context)!.notAssessed,
                              style: TextStyle(
                                color: AppColors.txtPrimary(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    hasAssessment
                                        ? 'BMI: ${bmi.toStringAsFixed(1)} • ${assessment.heightCm.toStringAsFixed(0)}cm • ${assessment.weightKg.toStringAsFixed(0)}kg'
                                        : AppLocalizations.of(context)!.completeAssessmentToSee,
                                    style: TextStyle(color: AppColors.txtMuted(context), fontSize: 12),
                                  ),
                                ),
                                if (hasAssessment)
                                  Icon(Icons.edit, color: AppColors.txtMuted(context), size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Column(
                    children: [
                      _buildMenuItem(context, Icons.person_outline, AppLocalizations.of(context)!.editProfile, AppColors.primary, () {
                        _showEditProfileSheet(context, ref, user);
                      }),
                      Divider(color: AppColors.bdr(context)),
                      _buildLanguageItem(context, ref),
                      Divider(color: AppColors.bdr(context)),
                      _buildDarkModeItem(context, ref),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: _buildMenuItem(context, Icons.logout, AppLocalizations.of(context)!.logout, AppColors.error, () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.crd(context),
                        title: Text(AppLocalizations.of(context)!.logout, style: TextStyle(color: AppColors.txtPrimary(context))),
                        content: Text(AppLocalizations.of(context)!.logoutConfirm, style: TextStyle(color: AppColors.txtSecondary(context))),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.txtMuted(context))),
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
    final imageUploadService = ImageUploadService();

    Uint8List? pickedImageBytes;
    String? pickedImageName;
    bool isUploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          decoration: BoxDecoration(
            color: AppColors.surf(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.editProfile,
                  style: TextStyle(color: AppColors.txtPrimary(context), fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: isUploading
                        ? null
                        : () async {
                            final result = await imageUploadService.pickImageBytes();
                            if (result != null) {
                              setSheetState(() {
                                pickedImageBytes = result['bytes'] as Uint8List;
                                pickedImageName = result['name'] as String;
                              });
                            }
                          },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        if (pickedImageBytes != null)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 3),
                              image: DecorationImage(
                                image: MemoryImage(pickedImageBytes!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else if (user?.photoUrl != null)
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
                            ),
                            child: Center(
                              child: Text(
                                (user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'A').toUpperCase(),
                                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: isUploading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (pickedImageBytes != null) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.photoSelected,
                      style: TextStyle(color: AppColors.success, fontSize: 12),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.fullName,
                    prefixIcon: Icon(Icons.person_outline, color: AppColors.txtMuted(context)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.txtMuted(context)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneOptional,
                    prefixIcon: Icon(Icons.phone_outlined, color: AppColors.txtMuted(context)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.bioOptional,
                    prefixIcon: Icon(Icons.info_outline, color: AppColors.txtMuted(context)),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                GradientButton(
                  text: isUploading ? AppLocalizations.of(context)!.uploading : AppLocalizations.of(context)!.saveChanges,
                  icon: isUploading ? null : Icons.save,
                  height: 50,
                  onPressed: isUploading
                      ? null
                      : () async {
                          final newName = nameController.text.trim();
                          final newEmail = emailController.text.trim();
                          final newPhone = phoneController.text.trim();
                          final newBio = bioController.text.trim();
                          if (newName.isEmpty) return;

                          setSheetState(() => isUploading = true);

                          String? photoUrl;
                          if (pickedImageBytes != null && pickedImageName != null) {
                            try {
                              photoUrl = await imageUploadService.uploadImage(
                                bytes: pickedImageBytes!,
                                fileName: pickedImageName!,
                              );
                            } catch (e) {
                              setSheetState(() => isUploading = false);
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text('${AppLocalizations.of(ctx)!.imageUploadFailed}: $e'),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                              return;
                            }
                          }

                          await ref.read(authRepositoryProvider).updateProfile(
                                fullName: newName,
                                email: newEmail.isNotEmpty ? newEmail : null,
                                photoUrl: photoUrl ?? user?.photoUrl,
                                phone: newPhone.isNotEmpty ? newPhone : null,
                                bio: newBio.isNotEmpty ? newBio : null,
                              );
                          if (ctx.mounted) {
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(ctx)!.profileUpdated),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: TextStyle(color: AppColors.txtPrimary(context), fontSize: 15)),
            ),
            Icon(Icons.chevron_right, color: AppColors.txtMuted(context), size: 20),
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
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
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
                  Text(AppLocalizations.of(context)!.settings, style: TextStyle(color: AppColors.txtPrimary(context), fontSize: 15)),
                  Text(langLabel, style: TextStyle(color: AppColors.txtMuted(context), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.txtMuted(context), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeItem(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return InkWell(
      onTap: () => ref.read(themeModeProvider.notifier).toggleTheme(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.warning,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDark ? AppLocalizations.of(context)!.darkMode : AppLocalizations.of(context)!.darkMode,
                    style: TextStyle(color: AppColors.txtPrimary(context), fontSize: 15),
                  ),
                  Text(
                    isDark ? 'ON' : 'OFF',
                    style: TextStyle(color: AppColors.txtMuted(context), fontSize: 12),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (_) => ref.read(themeModeProvider.notifier).toggleTheme(),
              activeColor: AppColors.primary,
            ),
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
        backgroundColor: AppColors.crd(context),
        title: Text('Language', style: TextStyle(color: AppColors.txtPrimary(context))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text('English', style: TextStyle(color: AppColors.txtPrimary(context))),
              value: const Locale('en'),
              groupValue: currentLocale,
              activeColor: AppColors.primary,
              onChanged: (locale) {
                if (locale != null) ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.of(ctx).pop();
              },
            ),
            RadioListTile<Locale>(
              title: Text('မြန်မာ', style: TextStyle(color: AppColors.txtPrimary(context))),
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
