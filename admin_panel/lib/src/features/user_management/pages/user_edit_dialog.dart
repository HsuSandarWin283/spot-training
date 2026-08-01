import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/features/user_management/providers/user_providers.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';

class UserEditDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;

  const UserEditDialog({super.key, required this.user});

  @override
  ConsumerState<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends ConsumerState<UserEditDialog> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.user['fullName'] as String? ?? '');
    _phoneController =
        TextEditingController(text: widget.user['phone'] as String? ?? '');
    _bioController =
        TextEditingController(text: widget.user['bio'] as String? ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.editProfile,
        style: const TextStyle(
          color: AdminColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fullName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.bio,
                  prefixIcon: const Icon(Icons.info_outline),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AdminColors.primary),
                  ),
                )
              : Text(
                  AppLocalizations.of(context)!.save,
                  style: const TextStyle(color: AdminColors.primary),
                ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(userServiceProvider).updateUser(widget.user['uid'] as String, {
        'fullName': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.userUpdatedSuccessfully),
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
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
