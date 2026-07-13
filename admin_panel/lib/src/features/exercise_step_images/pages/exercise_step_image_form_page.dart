// ignore_for_file: deprecated_member_use
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/models/exercise_step_image_model.dart';
import 'package:admin_panel/src/core/services/image_upload_service.dart';
import 'package:admin_panel/src/core/services/exercise_step_image_service.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/exercise_step_images/providers/exercise_step_image_providers.dart';
import 'package:admin_panel/src/features/sports_management/providers/sports_provider.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';

const _kOthers = '__others__';

class _ItemEntry {
  final TextEditingController descriptionController;
  String? existingImageUrl;
  Uint8List? imageBytes;
  String? fileName;

  _ItemEntry({String? imageUrl, String description = ''})
      : existingImageUrl = imageUrl,
        descriptionController = TextEditingController(text: description);

  bool get hasImage =>
      imageBytes != null ||
      (existingImageUrl != null && existingImageUrl!.isNotEmpty);

  void dispose() {
    descriptionController.dispose();
  }
}

class ExerciseStepImageFormPage extends ConsumerStatefulWidget {
  final ExerciseStepImagePost? post;

  const ExerciseStepImageFormPage({super.key, this.post});

  @override
  ConsumerState<ExerciseStepImageFormPage> createState() =>
      _ExerciseStepImageFormPageState();
}

class _ExerciseStepImageFormPageState
    extends ConsumerState<ExerciseStepImageFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _customTypeController;
  bool _isLoading = false;
  String? _selectedType;
  final List<_ItemEntry> _itemEntries = [];
  bool _itemsLoaded = false;

  bool get _isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _customTypeController = TextEditingController();
    _selectedType = widget.post?.type;
    if (!_isEditing) {
      _itemEntries.add(_ItemEntry());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isEditing && !_itemsLoaded) {
      _itemsLoaded = true;
      _loadExistingItems();
    }
  }

  Future<void> _loadExistingItems() async {
    final postId = widget.post!.id;
    final items = await ref
        .read(exerciseStepImageServiceProvider)
        .getItems(postId)
        .first;
    if (mounted) {
      setState(() {
        _itemEntries.clear();
        for (final item in items) {
          _itemEntries.add(_ItemEntry(
            imageUrl: item.imageUrl,
            description: item.description,
          ));
        }
        if (_itemEntries.isEmpty) {
          _itemEntries.add(_ItemEntry());
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customTypeController.dispose();
    for (final entry in _itemEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addItemEntry() {
    setState(() {
      _itemEntries.add(_ItemEntry());
    });
  }

  void _removeItemEntry(int index) {
    setState(() {
      _itemEntries[index].dispose();
      _itemEntries.removeAt(index);
    });
  }

  String? _resolveType() {
    if (_selectedType == _kOthers) {
      final custom = _customTypeController.text.trim();
      return custom.isEmpty ? null : custom;
    }
    return _selectedType;
  }

  Future<void> _pickItemImage(int index) async {
    try {
      final service = ImageUploadService();
      final result = await service.pickImageBytes();
      if (result != null) {
        setState(() {
          _itemEntries[index].imageBytes = result['bytes'] as Uint8List;
          _itemEntries[index].fileName = result['name'] as String;
          _itemEntries[index].existingImageUrl = null;
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final resolvedType = _resolveType();
    if (resolvedType == null || resolvedType.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Type is required.'),
            backgroundColor: AdminColors.error,
          ),
        );
      }
      return;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title is required.'),
            backgroundColor: AdminColors.error,
          ),
        );
      }
      return;
    }

    for (int i = 0; i < _itemEntries.length; i++) {
      if (_itemEntries[i].descriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item ${i + 1}: Description is required.'),
            backgroundColor: AdminColors.error,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(exerciseStepImageServiceProvider);

      if (_isEditing) {
        final pendingItems = _itemEntries
            .map((e) => PendingExerciseStepItem(
                  existingImageUrl:
                      e.imageBytes == null ? e.existingImageUrl : null,
                  imageBytes: e.imageBytes,
                  fileName: e.fileName,
                  description: e.descriptionController.text.trim(),
                ))
            .toList();

        await service.updatePost(
          postId: widget.post!.id,
          title: title,
          type: resolvedType,
          pendingItems: pendingItems,
        );
      } else {
        final sports = ref.read(sportsListProvider).valueOrNull ?? [];
        final matchedSport = sports.where((s) => s.name == resolvedType);
        final sportId = matchedSport.isNotEmpty ? matchedSport.first.id : '';

        final pendingItems = _itemEntries
            .map((e) => PendingExerciseStepItem(
                  imageBytes: e.imageBytes,
                  fileName: e.fileName,
                  description: e.descriptionController.text.trim(),
                ))
            .toList();

        await service.createPost(
          title: title,
          type: resolvedType,
          sportId: sportId,
          pendingItems: pendingItems,
        );
      }

      ref.invalidate(exerciseStepImagePostsProvider);
      ref.invalidate(exerciseStepImageTypesProvider);
      if (mounted) {
        ref.read(adminViewProvider.notifier).state =
            AdminView.exerciseStepImages;
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sportsAsync = ref.watch(sportsListProvider);
    final typesAsync = ref.watch(exerciseStepImageTypesProvider);

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
                      AdminView.exerciseStepImages;
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditing ? 'Edit Post' : 'Create Post',
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isEditing
                          ? widget.post!.title
                          : 'Add exercise step images',
                      style: const TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
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
                    if (!_isEditing)
                      _buildTypeSection(sportsAsync, typesAsync),
                    if (_isEditing)
                      _buildTypeSection(sportsAsync, typesAsync),
                    if (_selectedType == _kOthers) ...[
                      const SizedBox(height: 16),
                      AdminCard(
                        child: TextFormField(
                          controller: _customTypeController,
                          decoration: const InputDecoration(
                            labelText: 'Custom Type Name',
                            prefixIcon:
                                Icon(Icons.edit, color: AdminColors.textMuted),
                          ),
                          validator: (value) {
                            if (_selectedType == _kOthers &&
                                (value == null || value.trim().isEmpty)) {
                              return 'Custom type name is required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    AdminCard(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Post Title',
                          prefixIcon:
                              Icon(Icons.title, color: AdminColors.textMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required.';
                          }
                          return null;
                        },
                      ),
                    ),
                    _buildItemsSection(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: _isEditing ? 'Update Post' : 'Create Post',
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
        ],
      ),
    );
  }

  Widget _buildTypeSection(
      AsyncValue<List<SportModel>> sportsAsync, AsyncValue<List<String>> typesAsync) {
    final sports = sportsAsync.valueOrNull ?? [];
    final existingTypes = typesAsync.valueOrNull ?? [];

    final List<String> allTypes = [];
    final Set<String> added = {};

    for (final sport in sports) {
      if (added.add(sport.name)) {
        allTypes.add(sport.name);
      }
    }
    for (final t in existingTypes) {
      if (added.add(t)) {
        allTypes.add(t);
      }
    }
    allTypes.sort();

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Post Type',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AdminColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AdminColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                hint: const Text(
                  'Select a type',
                  style: TextStyle(color: AdminColors.textMuted),
                ),
                dropdownColor: AdminColors.surface,
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 14,
                ),
                items: [
                  ...allTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          const Icon(Icons.label,
                              size: 16, color: AdminColors.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(type)),
                        ],
                      ),
                    );
                  }),
                  const DropdownMenuItem(
                    value: _kOthers,
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline,
                            size: 16, color: AdminColors.warning),
                        SizedBox(width: 8),
                        Text('Others',
                            style: TextStyle(
                                color: AdminColors.warning,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Images & Descriptions',
                  style: TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${_itemEntries.length} item${_itemEntries.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  color: AdminColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '* At least one image + description is required',
            style: TextStyle(
              color: AdminColors.warning,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          if (_itemEntries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No items. Tap "Add Image" below to add one.',
                style: TextStyle(color: AdminColors.error, fontSize: 13),
              ),
            ),
          ..._itemEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildItemEntryRow(index, item);
          }),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addItemEntry,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Image'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemEntryRow(int index, _ItemEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                'Image ${index + 1}',
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
                onPressed: _itemEntries.length > 1
                    ? () => _removeItemEntry(index)
                    : null,
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
          GestureDetector(
            onTap: () => _pickItemImage(index),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: AdminColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AdminColors.border, width: 1),
              ),
              child: _buildItemPreview(index, entry),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _pickItemImage(index),
              icon: const Icon(Icons.upload_outlined, size: 16),
              label: Text(
                entry.hasImage ? 'Change Image' : 'Select Image',
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: entry.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

  Widget _buildItemPreview(int index, _ItemEntry entry) {
    if (entry.imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(entry.imageBytes!, fit: BoxFit.cover),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (entry.existingImageUrl != null && entry.existingImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              entry.existingImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildItemPlaceholder(),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      );
    }

    return _buildItemPlaceholder();
  }

  Widget _buildItemPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 40,
            color: AdminColors.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to select an image',
            style: TextStyle(
              color: AdminColors.textMuted.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
