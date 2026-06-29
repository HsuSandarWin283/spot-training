import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:ai_sports_training/src/core/services/local_storage_provider.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToMain(),
        ),
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
              final localStorage = await ref.read(localStorageServiceProvider.future);
              final rememberMe = localStorage.isRememberMe;
              await ref.read(authRepositoryProvider).signOut();
              if (!rememberMe) {
                await localStorage.clearRememberEmail();
                await localStorage.setRememberMe(false);
              }
              if (context.mounted) context.goToLogin();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}