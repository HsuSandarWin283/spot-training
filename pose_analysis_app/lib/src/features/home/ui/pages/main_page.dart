import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';
import 'package:ai_sports_training/src/core/services/local_storage_provider.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToLogin(),
        ),
        title: const Text('AI Sports Training'),
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
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => context.goToHome(),
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Pose Detection'),
            onTap: () => context.goToPoseDetection(),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Training Plan'),
            onTap: () => context.goToTrainingPlan(),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => context.goToProfile(),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => context.goToSettings(),
          ),
        ],
      ),
    );
  }
}