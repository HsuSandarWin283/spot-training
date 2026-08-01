// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/services/fitness_assessment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasNavigated = false;
  bool _showAuthButtons = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _checkAuth();
  }

  void _checkAuth() {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted || _hasNavigated) return;

      try {
        final firebaseUser = fb.FirebaseAuth.instance.currentUser;

        if (firebaseUser != null) {
          _hasNavigated = true;
          final assessmentService = FitnessAssessmentService();
          final hasCompleted = await assessmentService.hasCompletedAssessment(firebaseUser.uid);
          if (!mounted) return;
          if (hasCompleted) {
            context.go('/main');
          } else {
            context.go('/fitness-assessment');
          }
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        final hasSelectedLanguage = prefs.getBool('hasSelectedLanguage') ?? false;
        if (!hasSelectedLanguage) {
          _hasNavigated = true;
          if (mounted) context.go('/language');
          return;
        }

        _hasNavigated = true;
        if (mounted) setState(() => _showAuthButtons = true);
      } catch (e) {
        _hasNavigated = true;
        if (mounted) {
          context.go('/main');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF151A30),
                  Color(0xFF0A0E21),
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: AppColors.primaryGradient,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.4),
                                              blurRadius: 30,
                                              spreadRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.fitness_center,
                                          size: 56,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'AI Sports Training',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        AppLocalizations.of(context)?.splashSubtitle ?? 'Pose Analysis Assistant',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_showAuthButtons)
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)?.splashDescription ?? 'Master your sport with AI-powered pose analysis and personalized training plans.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textMuted,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      GradientButton(
                                        text: AppLocalizations.of(context)?.signUp ?? 'Sign Up',
                                        icon: Icons.person_add,
                                        height: 50,
                                        onPressed: () => context.go('/register'),
                                      ),
                                      const SizedBox(height: 12),
                                      OutlineButton(
                                        text: AppLocalizations.of(context)?.login ?? 'Login',
                                        height: 50,
                                        onPressed: () => context.go('/login'),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (!_showAuthButtons)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
