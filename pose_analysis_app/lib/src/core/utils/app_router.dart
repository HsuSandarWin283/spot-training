import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/splash/ui/pages/splash_screen.dart';
import 'package:ai_sports_training/src/features/sports_selection/ui/pages/sports_selection_screen.dart';
import 'package:ai_sports_training/src/features/sport_detail/ui/pages/sport_detail_screen.dart';
import 'package:ai_sports_training/src/features/ai_recommendation/ui/pages/ai_recommendation_screen.dart';
import 'package:ai_sports_training/src/features/weekly_plan/ui/pages/weekly_plan_screen.dart';
import 'package:ai_sports_training/src/features/pose_analysis/ui/pages/pose_analysis_screen.dart';
import 'package:ai_sports_training/src/features/pose_feedback/ui/pages/pose_feedback_screen.dart';
import 'package:ai_sports_training/src/features/training_details/ui/pages/training_details_screen.dart';
import 'package:ai_sports_training/src/features/injury_prevention/ui/pages/injury_prevention_screen.dart';
import 'package:ai_sports_training/src/features/dashboard/ui/pages/dashboard_screen.dart';
import 'package:ai_sports_training/src/features/profile/ui/pages/profile_page.dart';
import 'package:ai_sports_training/src/features/auth/ui/pages/login_page.dart';
import 'package:ai_sports_training/src/features/auth/ui/pages/register_page.dart';
import 'package:ai_sports_training/src/features/home/ui/pages/main_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) {
          final index = (state.extra as int?) ?? 0;
          return MainPage(initialIndex: index);
        },
      ),
      GoRoute(
        path: '/sport-detail/:sportId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SportDetailScreen(
          sportId: state.pathParameters['sportId']!,
        ),
      ),
      GoRoute(
        path: '/ai-recommendation',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AIRecommendationScreen(),
      ),
      GoRoute(
        path: '/weekly-plan',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WeeklyPlanScreen(),
      ),
      GoRoute(
        path: '/pose-feedback',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PoseFeedbackScreen(),
      ),
      GoRoute(
        path: '/training-details',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TrainingDetailsScreen(),
      ),
      GoRoute(
        path: '/injury-prevention',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InjuryPreventionScreen(),
      ),
    ],
  );
});

class AppRouter {
  static GoRouter router(WidgetRef ref) => ref.watch(_routerProvider);
}

extension GoRouterExtension on BuildContext {
  void goToSplash() => go('/');
  void goToLogin() => go('/login');
  void goToRegister() => go('/register');
  void goToMain() => go('/main');
  void goToMainTab(int index) => go('/main', extra: index);
  void goToSportDetail(String sportId) => push('/sport-detail/$sportId');
  void goToAIRecommendation() => push('/ai-recommendation');
  void goToWeeklyPlan() => push('/weekly-plan');
  void goToPoseAnalysis() => go('/main');
  void goToPoseFeedback() => push('/pose-feedback');
  void goToTrainingDetails() => push('/training-details');
  void goToInjuryPrevention() => push('/injury-prevention');
}
