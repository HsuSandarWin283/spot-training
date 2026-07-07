// ignore_for_file: deprecated_member_use
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/sports_management/providers/sports_provider.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';

class SportFormPage extends ConsumerStatefulWidget {
  final SportModel? sport;

  const SportFormPage({super.key, this.sport});

  @override
  ConsumerState<SportFormPage> createState() => _SportFormPageState();
}

class _SportFormPageState extends ConsumerState<SportFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _difficultyLevel = 'Beginner';
  bool _isLoading = false;
  String? _existingThumbnailUrl;

  final List<String> _difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sport?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.sport?.description ?? '');
    _difficultyLevel = widget.sport?.difficultyLevel ?? 'Beginner';
    _existingThumbnailUrl = widget.sport?.thumbnailUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.sport != null;

  Future<void> _pickThumbnail() async {
    try {
      // Use a simple approach: show a dialog to enter image URL for web
      final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (ctx) {
          final urlController = TextEditingController();
          return AlertDialog(
            title: const Text('Add Thumbnail Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter an image URL for the sport thumbnail:',
                  style: TextStyle(color: AdminColors.textSecondary),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    hintText: 'https://example.com/image.jpg',
                    labelText: 'Image URL',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (urlController.text.isNotEmpty) {
                    Navigator.of(ctx).pop({'url': urlController.text});
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );

      if (result != null && result['url'] != null) {
        setState(() {
          _existingThumbnailUrl = result['url'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AdminColors.error,
          ),
        );
      }
    }
  }

  Future<void> _saveSport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        await ref.read(sportServiceProvider).updateSport(
              id: widget.sport!.id,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              difficultyLevel: _difficultyLevel,
              thumbnailUrl: _existingThumbnailUrl ?? '',
            );
      } else {
        await ref.read(sportServiceProvider).addSport(
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              difficultyLevel: _difficultyLevel,
              thumbnailUrl: _existingThumbnailUrl ?? '',
            );
      }

      ref.invalidate(sportsListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                _isEditing ? 'Sport updated successfully' : 'Sport added successfully'),
            backgroundColor: AdminColors.success,
          ),
        );
        ref.read(adminViewProvider.notifier).state = AdminView.sports;
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
                  ref.read(adminViewProvider.notifier).state = AdminView.sports;
                },
              ),
              const SizedBox(width: 8),
              Text(
                _isEditing ? 'Edit Sport' : 'Add New Sport',
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sport Information',
                            style: TextStyle(
                              color: AdminColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Sport Name',
                              prefixIcon: Icon(Icons.sports,
                                  color: AdminColors.textMuted),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Sport name is required';
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
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Description is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _difficultyLevel,
                            decoration: const InputDecoration(
                              labelText: 'Difficulty Level',
                              prefixIcon: Icon(Icons.signal_cellular_alt,
                                  color: AdminColors.textMuted),
                            ),
                            items: _difficultyLevels.map((level) {
                              return DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _difficultyLevel = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AdminCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thumbnail Image',
                            style: TextStyle(
                              color: AdminColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_existingThumbnailUrl != null &&
                              _existingThumbnailUrl!.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _existingThumbnailUrl!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: AdminColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AdminColors.border),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.image,
                                        size: 48,
                                        color: AdminColors.textMuted),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _existingThumbnailUrl = null;
                                  });
                                },
                                icon: const Icon(Icons.close,
                                    size: 16, color: AdminColors.error),
                                label: const Text('Remove',
                                    style:
                                        TextStyle(color: AdminColors.error)),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _pickThumbnail,
                              icon: const Icon(Icons.upload_outlined),
                              label: Text(
                                (_existingThumbnailUrl?.isNotEmpty ?? false)
                                    ? 'Change Image'
                                    : 'Upload Thumbnail',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: _isEditing ? 'Update Sport' : 'Add Sport',
                        icon: _isEditing ? Icons.save : Icons.add,
                        isLoading: _isLoading,
                        onPressed: _saveSport,
                      ),
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
}
