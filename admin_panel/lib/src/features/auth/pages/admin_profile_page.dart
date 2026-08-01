// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';

class AdminProfilePage extends ConsumerStatefulWidget {
  const AdminProfilePage({super.key});

  @override
  ConsumerState<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends ConsumerState<AdminProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _photoUrlController;
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final user = ref.read(currentUserProvider);
      _nameController = TextEditingController(text: user?.displayName ?? '');
      _emailController = TextEditingController(text: user?.email ?? '');
      _photoUrlController = TextEditingController(text: user?.photoURL ?? '');
    }
  }

  @override
  void dispose() {
    if (_initialized) {
      _nameController.dispose();
      _emailController.dispose();
      _photoUrlController.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(sportServiceProvider).updateAdminProfile(
            displayName: _nameController.text.trim(),
            email: _emailController.text.trim().isNotEmpty
                ? _emailController.text.trim()
                : null,
            photoUrl: _photoUrlController.text.trim().isNotEmpty
                ? _photoUrlController.text.trim()
                : null,
          );
      ref.invalidate(authStateProvider);
      ref.invalidate(currentUserProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileUpdatedSuccessfully),
            backgroundColor: AdminColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AdminColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.myProfile,
            style: const TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.manageAdminAccount,
            style: const TextStyle(
              color: AdminColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      if (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AdminColors.primary, width: 3),
                            image: DecorationImage(
                              image: NetworkImage(user.photoURL!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AdminColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AdminColors.primary.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              ((user?.displayName?.isNotEmpty == true)
                                      ? user!.displayName![0]
                                      : (user?.email?.isNotEmpty == true)
                                          ? user!.email![0]
                                          : 'A')
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? AppLocalizations.of(context)!.admin,
                    style: const TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: AdminColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AdminColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.admin,
                      style: const TextStyle(
                        color: AdminColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.editProfile,
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.displayName,
                            prefixIcon: const Icon(Icons.person_outline,
                                color: AdminColors.textMuted),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.email,
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: AdminColors.textMuted),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _photoUrlController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.profilePhotoUrl,
                            prefixIcon: const Icon(Icons.link,
                                color: AdminColors.textMuted),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            text: AppLocalizations.of(context)!.saveChanges,
                            icon: Icons.save,
                            isLoading: _isLoading,
                            onPressed: _save,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
