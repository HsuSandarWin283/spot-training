// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/services/fitness_assessment_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return AppLocalizations.of(context)!.emailRequired;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return AppLocalizations.of(context)!.enterValidEmail;
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
    if (value.length < 8) return AppLocalizations.of(context)!.passwordMinLength;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(authStateProvider, (prev, next) {
      next.whenData((user) async {
        if (user != null && mounted) {
          try {
            final service = FitnessAssessmentService();
            final hasCompleted = await service.hasCompletedAssessment(user.uid);
            if (!mounted) return;
            if (hasCompleted) {
              context.go('/main');
            } else {
              context.go('/fitness-assessment');
            }
          } catch (e) {
            if (mounted) context.go('/main');
          }
        }
      });
    });

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
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 24,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.welcomeBack,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.signInToContinue,
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.email,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password,
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 24),
                      GradientButton(
                        text: _isLoading ? AppLocalizations.of(context)!.signingIn : AppLocalizations.of(context)!.signIn,
                        icon: _isLoading ? null : Icons.arrow_forward,
                        onPressed: _isLoading ? () {} : _signIn,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dontHaveAccount,
                            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
