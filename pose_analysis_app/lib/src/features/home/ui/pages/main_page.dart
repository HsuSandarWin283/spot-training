import 'package:flutter/material.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/features/dashboard/ui/pages/dashboard_screen.dart';
import 'package:ai_sports_training/src/features/sports_selection/ui/pages/sports_selection_screen.dart';
import 'package:ai_sports_training/src/features/exercise_step_poses/ui/pages/exercise_step_poses_screen.dart';
import 'package:ai_sports_training/src/features/injury_prevention/ui/pages/injury_prevention_screen.dart';
import 'package:ai_sports_training/src/features/profile/ui/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;
  const MainPage({super.key, this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardScreen(
            onProfileTap: () => setState(() => _currentIndex = 4),
            onAnalysisTap: () => setState(() => _currentIndex = 2),
          ),
          const SportsSelectionScreen(),
          const ExerciseStepPosesScreen(),
          const InjuryPreventionScreen(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surf(context),
          border: Border(
            top: BorderSide(color: AppColors.bdr(context), width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, AppLocalizations.of(context)!.home),
                _buildNavItem(1, Icons.sports_soccer, AppLocalizations.of(context)!.training),
                _buildNavItem(2, Icons.photo_library_outlined, AppLocalizations.of(context)!.poses),
                _buildNavItem(3, Icons.health_and_safety, AppLocalizations.of(context)!.injuryPreventionLabel),
                _buildNavItem(4, Icons.person_rounded, AppLocalizations.of(context)!.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.txtMuted(context),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.txtMuted(context),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
