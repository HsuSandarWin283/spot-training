import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/auth/ui/pages/login_page.dart';
import 'package:ai_sports_training/src/features/auth/ui/pages/register_page.dart';
import 'package:ai_sports_training/src/features/home/ui/pages/home_page.dart';
import 'package:ai_sports_training/src/features/home/ui/pages/main_page.dart';
import 'package:ai_sports_training/src/features/pose_detection/ui/pages/pose_detection_page.dart';
import 'package:ai_sports_training/src/features/training_plan/ui/pages/training_plan_page.dart';
import 'package:ai_sports_training/src/features/profile/ui/pages/profile_page.dart';
import 'package:ai_sports_training/src/features/settings/ui/pages/settings_page.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return '/main';
      }

      if (!isAuthenticated && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/pose-detection',
        builder: (context, state) => const PoseDetectionPage(),
      ),
      GoRoute(
        path: '/training-plan',
        builder: (context, state) => const TrainingPlanPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});

class AppRouter {
  static GoRouter router(WidgetRef ref) => ref.watch(_routerProvider);
}

extension GoRouterExtension on BuildContext {
  void goToLogin() => go('/login');
  void goToRegister() => go('/register');
  void goToHome() => go('/home');
  void goToMain() => go('/main');
  void goToPoseDetection() => go('/pose-detection');
  void goToTrainingPlan() => go('/training-plan');
  void goToProfile() => go('/profile');
  void goToSettings() => go('/settings');
}
