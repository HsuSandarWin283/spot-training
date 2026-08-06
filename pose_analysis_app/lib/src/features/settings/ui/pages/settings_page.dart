import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:ai_sports_training/src/core/services/local_storage_provider.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
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
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToMain(),
        ),
        title: Text(l10n.settings),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(l10n.logout),
                  content: Text(l10n.logoutConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: Text(l10n.logout),
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
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settings),
            subtitle: Text(
              currentLocale.languageCode == 'my' ? 'မြန်မာ' : 'English',
              style: TextStyle(color: AppColors.primary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context),
          ),
          SwitchListTile(
            title: Text(l10n.darkMode),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          SwitchListTile(
            title: Text(l10n.notifications),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.about),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(l10n.helpSupport),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text('English'),
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
              title: Text('မြန်မာ'),
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
