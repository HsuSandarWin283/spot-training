// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/models/sport_detail_models.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/sport_detail/providers/sport_detail_providers.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';

class SportDetailFormPage extends ConsumerStatefulWidget {
  final SportDetailType? detailType;
  final SportDetailItem? item;

  const SportDetailFormPage({super.key, this.detailType, this.item});

  @override
  ConsumerState<SportDetailFormPage> createState() =>
      _SportDetailFormPageState();
}

class _SportDetailFormPageState extends ConsumerState<SportDetailFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late SportDetailType _selectedType;
  bool _isLoading = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.item?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.item?.description ?? '');
    _selectedType = widget.detailType ?? SportDetailType.rules;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.detailType == null) {
      _selectedType = ref.read(currentDetailTypeProvider);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final sportId = ref.read(selectedSportIdProvider);

    if (sportId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sport is required.'),
            backgroundColor: AdminColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        await ref.read(sportDetailServiceProvider).updateItem(
              id: widget.item!.id,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              type: _selectedType,
            );
      } else {
        await ref.read(sportDetailServiceProvider).addItem(
              sportId: sportId,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              type: _selectedType,
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? '${_selectedType.singularLabel} updated successfully'
                  : '${_selectedType.singularLabel} added successfully',
            ),
            backgroundColor: AdminColors.success,
          ),
        );
        ref.read(adminViewProvider.notifier).state = AdminView.sportDetail;
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
    final sportName = ref.watch(selectedSportNameProvider);

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
                      AdminView.sportDetail;
                },
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditing
                        ? 'Edit ${_selectedType.singularLabel}'
                        : 'Add ${_selectedType.singularLabel}',
                    style: const TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sport: $sportName',
                    style: const TextStyle(
                      color: AdminColors.textSecondary,
                      fontSize: 14,
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
                        '${_selectedType.singularLabel} Information',
                        style: const TextStyle(
                          color: AdminColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!_isEditing) ...[
                        DropdownButtonFormField<SportDetailType>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category,
                                color: AdminColors.textMuted),
                          ),
                          items: SportDetailType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.label),
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
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title,
                              color: AdminColors.textMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description_outlined,
                              color: AdminColors.textMuted),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          text: _isEditing
                              ? 'Update ${_selectedType.singularLabel}'
                              : 'Add ${_selectedType.singularLabel}',
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
