import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/services/locale_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.bg(context), AppColors.surf(context), AppColors.bg(context)],
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
                  colors: [AppColors.primary.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
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
                      child: const Icon(Icons.language, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'AI Sports Training',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.txtPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose your language',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.txtSecondary(context),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildLanguageButton(
                      context,
                      ref,
                      locale: const Locale('en'),
                      flag: '🇺🇸',
                      label: 'English',
                      subtitle: 'Continue in English',
                    ),
                    const SizedBox(height: 16),
                    _buildLanguageButton(
                      context,
                      ref,
                      locale: const Locale('my'),
                      flag: '🇲🇲',
                      label: 'မြန်မာ',
                      subtitle: 'မြန်မာဘာသာဖြင့် ဆက်လက်ဆောင်ရွက်ပါ',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    WidgetRef ref, {
    required Locale locale,
    required String flag,
    required String label,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () async {
        ref.read(localeProvider.notifier).setLocale(locale);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSelectedLanguage', true);
        if (context.mounted) context.go('/');
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.crd(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.bdr(context), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 36)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.txtPrimary(context),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.txtMuted(context),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.txtMuted(context), size: 18),
          ],
        ),
      ),
    );
  }
}
