import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/fitness_assessment.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/providers/fitness_assessment_providers.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:go_router/go_router.dart';

class FitnessAssessmentScreen extends ConsumerStatefulWidget {
  const FitnessAssessmentScreen({super.key});

  @override
  ConsumerState<FitnessAssessmentScreen> createState() =>
      _FitnessAssessmentScreenState();
}

class _FitnessAssessmentScreenState
    extends ConsumerState<FitnessAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  Gender _selectedGender = Gender.male;
  int _exerciseFrequency = 1;
  int _activityLevel = 1;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitAssessment() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      setState(() => _errorMessage = 'Not signed in');
      return;
    }
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    if (age == null || height == null || weight == null) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      double strength = 50;
      double flexibility = 50;
      double balance = 50;
      double coordination = 50;

      if (_exerciseFrequency >= 4) {
        strength += 20;
        balance += 15;
        coordination += 15;
      } else if (_exerciseFrequency >= 2) {
        strength += 10;
        balance += 8;
        coordination += 8;
      }

      if (_activityLevel >= 3) {
        flexibility += 15;
        strength += 10;
      } else if (_activityLevel >= 2) {
        flexibility += 8;
        strength += 5;
      }

      final bmi = weight / ((height / 100) * (height / 100));
      if (bmi >= 18.5 && bmi <= 24.9) {
        balance += 10;
        coordination += 10;
      }

      if (age < 30) {
        strength += 10;
        coordination += 10;
      } else if (age < 50) {
        strength += 5;
        coordination += 5;
      }

      strength = strength.clamp(0, 100);
      flexibility = flexibility.clamp(0, 100);
      balance = balance.clamp(0, 100);
      coordination = coordination.clamp(0, 100);

      final overall =
          strength * 0.3 + flexibility * 0.2 + balance * 0.25 + coordination * 0.25;

      FitnessLevel level;
      if (overall >= 75) {
        level = FitnessLevel.advanced;
      } else if (overall >= 50) {
        level = FitnessLevel.intermediate;
      } else {
        level = FitnessLevel.beginner;
      }

      final service = ref.read(fitnessAssessmentServiceProvider);
      final assessment = FitnessAssessment(
        id: '',
        userId: user.uid,
        age: age,
        gender: _selectedGender,
        heightCm: height,
        weightKg: weight,
        strengthScore: strength,
        flexibilityScore: flexibility,
        balanceTotalScore: balance,
        coordinationScore: coordination,
        overallScore: overall,
        fitnessLevel: level,
        isCompleted: true,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );

      await service.createAssessment(assessment);

      if (mounted) {
        ref.invalidate(hasCompletedAssessmentProvider);
        ref.invalidate(latestAssessmentProvider);
        context.go('/main');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to save: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, Color(0xFF0D1229)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Spacer(),
                    const Text(
                      'Fitness Assessment',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    _errorMessage!,
                    style:
                        const TextStyle(color: AppColors.error, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.person_outline,
                                        color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Basic Information',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Tell us about your body',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildInputField(
                                controller: _ageController,
                                label: 'Age',
                                icon: Icons.cake_outlined,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  final n = int.tryParse(v.trim());
                                  if (n == null || n < 5 || n > 120) {
                                    return 'Enter valid age';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildGenderDropdown(),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _heightController,
                                label: 'Height (cm)',
                                icon: Icons.height,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  final n = double.tryParse(v.trim());
                                  if (n == null || n < 50 || n > 300) {
                                    return 'Enter valid height';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _weightController,
                                label: 'Weight (kg)',
                                icon: Icons.monitor_weight_outlined,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  final n = double.tryParse(v.trim());
                                  if (n == null || n < 10 || n > 500) {
                                    return 'Enter valid weight';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                        Icons.fitness_center,
                                        color: Colors.white,
                                        size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Activity Level',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'How active are you?',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'How often do you exercise per week?',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildFrequencySelector(),
                              const SizedBox(height: 24),
                              const Text(
                                'What is your daily activity level?',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildActivityLevelSelector(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        GradientButton(
                          text: _isSaving
                              ? 'Saving...'
                              : 'Complete Assessment',
                          icon: Icons.check_circle_outline,
                          onPressed: _isSaving ? () {} : _submitAssessment,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<Gender>(
      value: _selectedGender,
      onChanged: (v) {
        if (v != null) setState(() => _selectedGender = v);
      },
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      dropdownColor: AppColors.card,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.wc_outlined,
            color: AppColors.textMuted, size: 20),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: const [
        DropdownMenuItem(value: Gender.male, child: Text('Male')),
        DropdownMenuItem(value: Gender.female, child: Text('Female')),
        DropdownMenuItem(value: Gender.other, child: Text('Other')),
      ],
    );
  }

  Widget _buildFrequencySelector() {
    final options = [
      (0, 'Never'),
      (1, '1x'),
      (2, '2-3x'),
      (3, '3-4x'),
      (4, '5+x'),
    ];
    return Row(
      children: options.map((opt) {
        final isSelected = _exerciseFrequency == opt.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _exerciseFrequency = opt.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: opt.$1 < options.length - 1 ? 6 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.border,
                ),
              ),
              child: Text(
                opt.$2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityLevelSelector() {
    final options = [
      (0, 'Sedentary', Icons.airline_seat_recline_normal),
      (1, 'Light', Icons.directions_walk),
      (2, 'Moderate', Icons.directions_run),
      (3, 'Active', Icons.fitness_center),
    ];
    return Column(
      children: options.map((opt) {
        final isSelected = _activityLevel == opt.$1;
        return GestureDetector(
          onTap: () => setState(() => _activityLevel = opt.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(opt.$3,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textMuted,
                    size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    opt.$2,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
