// ignore_for_file: deprecated_member_use
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/core/services/image_upload_service.dart';
import 'package:admin_panel/src/core/models/sport_detail_models.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/sports_management/providers/sports_provider.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';
import 'package:admin_panel/src/features/sport_detail/providers/sport_detail_providers.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';

class _DetailEntry {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  _DetailEntry({String title = '', String description = ''})
      : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description);

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }
}

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
  bool _isLoading = false;
  String? _existingThumbnailUrl;
  Uint8List? _selectedImageBytes;
  String? _selectedFileName;

  final Map<SportDetailType, List<_DetailEntry>> _detailEntries = {
    SportDetailType.rules: [],
    SportDetailType.trainingMethods: [],
    SportDetailType.fitnessRequirements: [],
  };

  final Map<SportDetailType, bool> _sectionExpanded = {
    SportDetailType.rules: true,
    SportDetailType.trainingMethods: true,
    SportDetailType.fitnessRequirements: true,
  };

  bool get _isEditing => widget.sport != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sport?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.sport?.description ?? '');
    _existingThumbnailUrl = widget.sport?.thumbnailUrl;

    if (_isEditing) {
      _loadExistingDetails();
    }
  }

  Future<void> _loadExistingDetails() async {
    final sportId = widget.sport!.id;
    final service = ref.read(sportDetailServiceProvider);

    for (final type in SportDetailType.values.where((t) => t != SportDetailType.injuryPreventions)) {
      try {
        final items = await service.getItems(sportId, type).first;
        if (mounted) {
          setState(() {
            _detailEntries[type] = items
                .map((item) => _DetailEntry(
                      title: item.title,
                      description: item.description,
                    ))
                .toList();
          });
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final entries in _detailEntries.values) {
      for (final entry in entries) {
        entry.dispose();
      }
    }
    super.dispose();
  }

  void _addDetailEntry(SportDetailType type) {
    setState(() {
      _detailEntries[type]!.add(_DetailEntry());
    });
  }

  void _removeDetailEntry(SportDetailType type, int index) {
    setState(() {
      _detailEntries[type]![index].dispose();
      _detailEntries[type]!.removeAt(index);
    });
  }

  Future<void> _pickThumbnail() async {
    try {
      final service = ImageUploadService();
      final result = await service.pickImageBytes();
      if (result != null) {
        setState(() {
          _selectedImageBytes = result['bytes'] as Uint8List;
          _selectedFileName = result['name'] as String;
          _existingThumbnailUrl = null;
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

  String? _validateDetails() {
    for (final type in SportDetailType.values.where((t) => t != SportDetailType.injuryPreventions)) {
      final entries = _detailEntries[type]!;
      if (entries.isEmpty) {
        return '${type.label} requires at least one item.';
      }
      for (int i = 0; i < entries.length; i++) {
        if (entries[i].titleController.text.trim().isEmpty) {
          return '${type.label} - Item ${i + 1}: Title is required.';
        }
        if (entries[i].descriptionController.text.trim().isEmpty) {
          return '${type.label} - Item ${i + 1}: Description is required.';
        }
      }
    }
    return null;
  }

  Future<void> _saveSport() async {
    if (!_formKey.currentState!.validate()) return;

    final detailError = _validateDetails();
    if (detailError != null) {
      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(detailError),
              backgroundColor: AdminColors.error,
            ),
          );
        } catch (_) {}
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final detailService = ref.read(sportDetailServiceProvider);
      String sportId;

      String thumbnailUrl = _existingThumbnailUrl ?? '';
      if (_selectedImageBytes != null) {
        final uploadService = ImageUploadService();
        try {
          thumbnailUrl = await uploadService.uploadImage(
            bytes: _selectedImageBytes!,
            fileName: _selectedFileName ?? 'thumbnail.jpg',
            storagePath:
                'sports/thumbnails/${DateTime.now().millisecondsSinceEpoch}',
          );
        } catch (uploadError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Image upload failed: $uploadError\nSaving sport without new image.',
                ),
                backgroundColor: AdminColors.warning,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }

      if (_isEditing) {
        sportId = widget.sport!.id;
        await ref.read(sportServiceProvider).updateSport(
              id: sportId,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              difficultyLevel: 'Beginner',
              thumbnailUrl: thumbnailUrl,
            );

        for (final type in SportDetailType.values.where((t) => t != SportDetailType.injuryPreventions)) {
          final existing = await detailService.getItems(sportId, type).first;
          for (final old in existing) {
            await detailService.deleteItem(old.id, type);
          }
        }
      } else {
        sportId = await ref.read(sportServiceProvider).addSport(
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              difficultyLevel: 'Beginner',
              thumbnailUrl: thumbnailUrl,
            );
      }

      for (final type in SportDetailType.values.where((t) => t != SportDetailType.injuryPreventions)) {
        final entries = _detailEntries[type]!;
        for (final entry in entries) {
          final title = entry.titleController.text.trim();
          final desc = entry.descriptionController.text.trim();
          if (title.isNotEmpty && desc.isNotEmpty) {
            await detailService.addItem(
              sportId: sportId,
              title: title,
              description: desc,
              type: type,
            );
          }
        }
      }

      ref.invalidate(sportsListProvider);

      if (mounted) {
        ref.read(adminViewProvider.notifier).state = AdminView.sports;
      }
    } catch (e) {
      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AdminColors.error,
            ),
          );
        } catch (_) {}
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                _isEditing ? AppLocalizations.of(context)!.editSport : AppLocalizations.of(context)!.addNewSportTitle,
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
              constraints: const BoxConstraints(maxWidth: 700),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSportInfoCard(),
                    const SizedBox(height: 16),
                    _buildThumbnailCard(),
                    const SizedBox(height: 16),
                    _buildDetailSection(
                      SportDetailType.rules,
                      Icons.gavel,
                      AdminColors.primaryGradient,
                    ),
                    const SizedBox(height: 16),
                     _buildDetailSection(
                       SportDetailType.trainingMethods,
                       Icons.fitness_center,
                       AdminColors.successGradient,
                     ),
                     const SizedBox(height: 16),
                    _buildDetailSection(
                      SportDetailType.fitnessRequirements,
                      Icons.directions_run,
                      AdminColors.errorGradient,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: _isEditing ? AppLocalizations.of(context)!.updateSport : AppLocalizations.of(context)!.addSport,
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

  Widget _buildSportInfoCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.sportInformation,
            style: const TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.sportName,
              prefixIcon:
                  const Icon(Icons.sports, color: AdminColors.textMuted),
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
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.description,
              prefixIcon: const Icon(Icons.description_outlined,
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
        ],
      ),
    );
  }

  Widget _buildThumbnailCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.photo,
            style: const TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedImageBytes != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                _selectedImageBytes!,
                height: 320,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImageBytes = null;
                    _selectedFileName = null;
                  });
                },
                icon: const Icon(Icons.close,
                    size: 16, color: AdminColors.error),
                label: Text(AppLocalizations.of(context)!.remove,
                    style: const TextStyle(color: AdminColors.error)),
              ),
            ),
          ] else if (_existingThumbnailUrl != null &&
              _existingThumbnailUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _existingThumbnailUrl!,
                height: 320,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 320,
                  decoration: BoxDecoration(
                    color: AdminColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AdminColors.border),
                  ),
                  child: const Center(
                    child: Icon(Icons.image,
                        size: 48, color: AdminColors.textMuted),
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
                label: Text(AppLocalizations.of(context)!.remove,
                    style: const TextStyle(color: AdminColors.error)),
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
                (_existingThumbnailUrl?.isNotEmpty ?? false) || _selectedImageBytes != null
                    ? AppLocalizations.of(context)!.changeImage
                    : AppLocalizations.of(context)!.uploadImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    SportDetailType type,
    IconData icon,
    LinearGradient gradient,
  ) {
    final entries = _detailEntries[type]!;
    final expanded = _sectionExpanded[type]!;

    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _sectionExpanded[type] = !expanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.label,
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${entries.length} item${entries.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: AdminColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AdminColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(color: AdminColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  if (entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'At least one ${type.singularLabel.toLowerCase()} is required.',
                        style: const TextStyle(
                          color: AdminColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ...entries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _buildDetailEntryRow(type, index, item);
                  }),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _addDetailEntry(type),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('Add ${type.singularLabel}'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailEntryRow(
      SportDetailType type, int index, _DetailEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${type.singularLabel} ${index + 1}',
                style: const TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AdminColors.error, size: 18),
                onPressed: () => _removeDetailEntry(type, index),
                tooltip: 'Remove',
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: entry.titleController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.title,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Title is required.';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: entry.descriptionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.descriptionLabel,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
