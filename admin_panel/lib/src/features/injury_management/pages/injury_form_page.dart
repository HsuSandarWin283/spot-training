// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/models/injury_item.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/injury_management/providers/injury_providers.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';

class InjuryFormPage extends ConsumerStatefulWidget {
  final InjuryDataType? injuryType;
  final InjuryItem? item;

  const InjuryFormPage({super.key, this.injuryType, this.item});

  @override
  ConsumerState<InjuryFormPage> createState() => _InjuryFormPageState();
}

class _InjuryFormPageState extends ConsumerState<InjuryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleEnController;
  late TextEditingController _titleMmController;
  late TextEditingController _descriptionEnController;
  late TextEditingController _descriptionMmController;
  late InjuryDataType _selectedType;
  bool _isLoading = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _titleEnController =
        TextEditingController(text: widget.item?.titleEn ?? '');
    _titleMmController =
        TextEditingController(text: widget.item?.titleMm ?? '');
    _descriptionEnController =
        TextEditingController(text: widget.item?.descriptionEn ?? '');
    _descriptionMmController =
        TextEditingController(text: widget.item?.descriptionMm ?? '');
    _selectedType = widget.injuryType ?? InjuryDataType.prevention;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.injuryType == null) {
      _selectedType = ref.read(currentInjuryTypeProvider);
    }
  }

  @override
  void dispose() {
    _titleEnController.dispose();
    _titleMmController.dispose();
    _descriptionEnController.dispose();
    _descriptionMmController.dispose();
    super.dispose();
  }

  String _typeLabel(InjuryDataType type) {
    switch (type) {
      case InjuryDataType.prevention:
        return AppLocalizations.of(context)!.prevention;
      case InjuryDataType.treatment:
        return AppLocalizations.of(context)!.treatment;
    }
  }

  String _singularLabel(InjuryDataType type) {
    switch (type) {
      case InjuryDataType.prevention:
        return AppLocalizations.of(context)!.prevention;
      case InjuryDataType.treatment:
        return AppLocalizations.of(context)!.treatment;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        await ref.read(injuryServiceProvider).updateItem(
              id: widget.item!.id,
              type: _selectedType,
              titleEn: _titleEnController.text.trim(),
              titleMm: _titleMmController.text.trim(),
              descriptionEn: _descriptionEnController.text.trim(),
              descriptionMm: _descriptionMmController.text.trim(),
            );
      } else {
        await ref.read(injuryServiceProvider).addItem(
              type: _selectedType,
              titleEn: _titleEnController.text.trim(),
              titleMm: _titleMmController.text.trim(),
              descriptionEn: _descriptionEnController.text.trim(),
              descriptionMm: _descriptionMmController.text.trim(),
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? AppLocalizations.of(context)!
                      .typeUpdatedSuccessfully(_singularLabel(_selectedType))
                  : AppLocalizations.of(context)!
                      .typeAddedSuccessfully(_singularLabel(_selectedType)),
            ),
            backgroundColor: AdminColors.success,
          ),
        );
        ref.read(adminViewProvider.notifier).state =
            AdminView.injuryManagement;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AdminColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AdminColors.textPrimary, size: 20),
                onPressed: () {
                  ref.read(adminViewProvider.notifier).state =
                      AdminView.injuryManagement;
                },
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditing
                        ? AppLocalizations.of(context)!
                            .editType(_singularLabel(_selectedType))
                        : AppLocalizations.of(context)!
                            .addTypeTitle(_singularLabel(_selectedType)),
                    style: const TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: AdminCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .typeInformation(_typeLabel(_selectedType)),
                        style: const TextStyle(
                          color: AdminColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!_isEditing) ...[
                        DropdownButtonFormField<InjuryDataType>(
                          value: _selectedType,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.category,
                            prefixIcon: const Icon(Icons.category,
                                color: AdminColors.textMuted),
                          ),
                          items: InjuryDataType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(_typeLabel(type)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedType = value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _titleEnController,
                        decoration: InputDecoration(
                          labelText: 'Title (English)',
                          prefixIcon: const Icon(Icons.title,
                              color: AdminColors.textMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'English Title is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleMmController,
                        decoration: InputDecoration(
                          labelText: 'Title (မြန်မာ)',
                          prefixIcon: const Icon(Icons.title,
                              color: AdminColors.textMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Burmese Title is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionEnController,
                        decoration: InputDecoration(
                          labelText: 'Description (English)',
                          prefixIcon: const Icon(Icons.description_outlined,
                              color: AdminColors.textMuted),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'English Description is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionMmController,
                        decoration: InputDecoration(
                          labelText: 'Description (မြန်မာ)',
                          prefixIcon: const Icon(Icons.description_outlined,
                              color: AdminColors.textMuted),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Burmese Description is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          text: _isEditing
                              ? AppLocalizations.of(context)!
                                  .updateType(_singularLabel(_selectedType))
                              : AppLocalizations.of(context)!
                                  .addType(_singularLabel(_selectedType)),
                          icon: _isEditing ? Icons.save : Icons.add,
                          isLoading: _isLoading,
                          onPressed: _save,
                        ),
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
