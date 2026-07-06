// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

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
              children: [
                const CustomAppBar(title: 'Profile', showBack: false),
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
                          user?.fullName ?? 'Athlete',
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
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Intermediate Level',
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
                                    const Text('BMI', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
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
                                    const Text('Fitness', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
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
                                    const Text('Sessions', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
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
                              _buildMenuItem(Icons.person_outline, 'Edit Profile', AppColors.primary, () {
                                _showEditProfileSheet(context, ref, user);
                              }),
                              const Divider(color: AppColors.border),
                              _buildMenuItem(Icons.fitness_center, 'My Workouts', AppColors.secondary, () {}),
                              const Divider(color: AppColors.border),
                              _buildMenuItem(Icons.history, 'Training History', AppColors.warning, () {}),
                              const Divider(color: AppColors.border),
                              _buildMenuItem(Icons.notifications_outlined, 'Notifications', AppColors.accent, () {}),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GlassCard(
                          child: _buildMenuItem(Icons.logout, 'Logout', AppColors.error, () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.card,
                                title: const Text('Logout', style: TextStyle(color: AppColors.textPrimary)),
                                content: const Text('Are you sure you want to logout?', style: TextStyle(color: AppColors.textSecondary)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    child: const Text('Logout', style: TextStyle(color: AppColors.error)),
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
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, User? user) {
    final nameController = TextEditingController(text: user?.fullName ?? '');
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: photoController,
              decoration: const InputDecoration(
                labelText: 'Profile Image URL (optional)',
                prefixIcon: Icon(Icons.link, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Save Changes',
              icon: Icons.save,
              height: 50,
              onPressed: () async {
                final newName = nameController.text.trim();
                final newPhoto = photoController.text.trim();
                if (newName.isNotEmpty) {
                  await ref.read(authRepositoryProvider).updateProfile(
                        fullName: newName,
                        photoUrl: newPhoto.isNotEmpty ? newPhoto : null,
                      );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
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
}
