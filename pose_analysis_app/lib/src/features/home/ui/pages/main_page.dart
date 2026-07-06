import 'package:flutter/material.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/features/dashboard/ui/pages/dashboard_screen.dart';
import 'package:ai_sports_training/src/features/sports_selection/ui/pages/sports_selection_screen.dart';
import 'package:ai_sports_training/src/features/pose_analysis/ui/pages/pose_analysis_screen.dart';
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

  void switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardScreen(
            onProfileTap: () => setState(() => _currentIndex = 3),
            onAnalysisTap: () => setState(() => _currentIndex = 2),
          ),
          const SportsSelectionScreen(),
          const PoseAnalysisScreen(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, 'Home'),
                _buildNavItem(1, Icons.sports_soccer, 'Training'),
                _buildNavItem(2, Icons.accessibility_new, 'Analysis'),
                _buildNavItem(3, Icons.person_rounded, 'Profile'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textMuted,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
