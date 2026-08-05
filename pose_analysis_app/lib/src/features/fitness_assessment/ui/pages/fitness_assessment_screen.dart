import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/fitness_assessment.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/providers/fitness_assessment_providers.dart';
import 'package:ai_sports_training/src/features/auth/data/auth_provider.dart';
import 'package:go_router/go_router.dart';

class FitnessAssessmentScreen extends ConsumerStatefulWidget {
  final FitnessAssessment? existingAssessment;

  const FitnessAssessmentScreen({super.key, this.existingAssessment});

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

  bool get _isEditMode => widget.existingAssessment != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final a = widget.existingAssessment!;
      _ageController.text = a.age.toString();
      _heightController.text = a.heightCm.toStringAsFixed(0);
      _weightController.text = a.weightKg.toStringAsFixed(0);
      _selectedGender = a.gender;
      _exerciseFrequency = a.exerciseFrequency;
      _activityLevel = a.activityLevel;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitAssessment() async {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.read(currentUserProvider);
    if (user == null) {
      setState(() => _errorMessage = l10n.notSignedIn);
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
      final bmi = weight / ((height / 100) * (height / 100));

      double score = 0;
      score += _exerciseFrequency * 10;
      score += _activityLevel * 8;

      if (bmi >= 18.5 && bmi <= 24.9) {
        score += 15;
      } else if (bmi >= 17 && bmi <= 29) {
        score += 8;
      }

      if (age >= 15 && age <= 35) {
        score += 12;
      } else if (age >= 36 && age <= 55) {
        score += 8;
      } else {
        score += 4;
      }

      final overall = score.clamp(0, 100).toDouble();

      FitnessLevel level;
      if (overall >= 70) {
        level = FitnessLevel.advanced;
      } else if (overall >= 40) {
        level = FitnessLevel.intermediate;
      } else {
        level = FitnessLevel.beginner;
      }

      final service = ref.read(fitnessAssessmentServiceProvider);

      if (_isEditMode) {
        final updated = FitnessAssessment(
          id: widget.existingAssessment!.id,
          userId: user.uid,
          age: age,
          gender: _selectedGender,
          heightCm: height,
          weightKg: weight,
          exerciseFrequency: _exerciseFrequency,
          activityLevel: _activityLevel,
          overallScore: overall,
          fitnessLevel: level,
          isCompleted: true,
          createdAt: widget.existingAssessment!.createdAt,
        );
        await service.updateAssessment(updated);
      } else {
        final assessment = FitnessAssessment(
          id: '',
          userId: user.uid,
          age: age,
          gender: _selectedGender,
          heightCm: height,
          weightKg: weight,
          exerciseFrequency: _exerciseFrequency,
          activityLevel: _activityLevel,
          overallScore: overall,
          fitnessLevel: level,
          isCompleted: true,
          createdAt: DateTime.now(),
        );
        await service.createAssessment(assessment);
      }

      if (mounted) {
        ref.invalidate(hasCompletedAssessmentProvider);
        ref.invalidate(latestAssessmentProvider);
        if (_isEditMode) {
          Navigator.of(context).pop();
        } else {
          context.go('/main');
        }
      }
    } catch (e) {
      setState(() => _errorMessage = '${l10n.failedToSave} $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    if (_isEditMode)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              size: 18, color: AppColors.textPrimary),
                        ),
                      )
                    else
                      const SizedBox(width: 40),
                    const Spacer(),
                    Text(
                      _isEditMode ? l10n.editFitnessInfo : l10n.fitnessAssessment,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.basicInformation,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.tellUsAboutYourBody,
                                          style: const TextStyle(
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
                                label: l10n.age,
                                icon: Icons.cake_outlined,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return l10n.required;
                                  }
                                  final n = int.tryParse(v.trim());
                                  if (n == null || n < 5 || n > 120) {
                                    return l10n.enterValidAge;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildGenderDropdown(l10n),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _heightController,
                                label: l10n.heightCm,
                                icon: Icons.height,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return l10n.required;
                                  }
                                  final n = double.tryParse(v.trim());
                                  if (n == null || n < 50 || n > 300) {
                                    return l10n.enterValidHeight;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: _weightController,
                                label: l10n.weightKg,
                                icon: Icons.monitor_weight_outlined,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return l10n.required;
                                  }
                                  final n = double.tryParse(v.trim());
                                  if (n == null || n < 10 || n > 500) {
                                    return l10n.enterValidWeight;
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
                                    child: const Icon(Icons.fitness_center,
                                        color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.activityLevel,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.howActiveAreYou,
                                          style: const TextStyle(
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
                              Text(
                                l10n.exerciseFrequencyQuestion,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildFrequencySelector(l10n),
                              const SizedBox(height: 24),
                              Text(
                                l10n.dailyActivityQuestion,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildActivityLevelSelector(l10n),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        GradientButton(
                          text: _isSaving
                              ? l10n.saving
                              : _isEditMode
                                  ? l10n.saveChanges
                                  : l10n.completeAssessment,
                          icon: _isEditMode ? Icons.save : Icons.check_circle_outline,
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

  Widget _buildGenderDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<Gender>(
      value: _selectedGender,
      onChanged: (v) {
        if (v != null) setState(() => _selectedGender = v);
      },
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      dropdownColor: AppColors.card,
      decoration: InputDecoration(
        labelText: l10n.gender,
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
      items: [
        DropdownMenuItem(value: Gender.male, child: Text(l10n.male)),
        DropdownMenuItem(value: Gender.female, child: Text(l10n.female)),
        DropdownMenuItem(value: Gender.other, child: Text(l10n.other)),
      ],
    );
  }

  Widget _buildFrequencySelector(AppLocalizations l10n) {
    final options = [
      (0, l10n.never),
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

  Widget _buildActivityLevelSelector(AppLocalizations l10n) {
    final options = [
      (0, l10n.sedentary, Icons.airline_seat_recline_normal),
      (1, l10n.light, Icons.directions_walk),
      (2, l10n.moderate, Icons.directions_run),
      (3, l10n.active, Icons.fitness_center),
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
