import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/src/core/models/exercise_step_image_model.dart';
import 'package:admin_panel/src/core/services/image_upload_service.dart';

class ExerciseStepImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _postsCollection =>
      _firestore.collection('exercise_step_image_posts');

  CollectionReference _itemsCollection(String postId) =>
      _postsCollection.doc(postId).collection('items');

  Stream<List<ExerciseStepImagePost>> getPosts() {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExerciseStepImagePost.fromFirestore(doc))
            .toList());
  }

  Stream<List<ExerciseStepImageItem>> getItems(String postId) {
    return _itemsCollection(postId)
        .orderBy('stepOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExerciseStepImageItem.fromFirestore(doc))
            .toList());
  }

  Future<List<String>> getAllTypes() async {
    final snapshot = await _postsCollection.get();
    final types = <String>{};
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final type = data['type'] as String?;
      if (type != null && type.isNotEmpty) {
        types.add(type);
      }
    }
    final sorted = types.toList()..sort();
    return sorted;
  }

  Future<String> createPost({
    required String titleEn,
    required String titleMm,
    required String type,
    required List<PendingExerciseStepItem> pendingItems,
    String sportId = '',
  }) async {
    final docRef = await _postsCollection.add({
      'titleEn': titleEn,
      'titleMm': titleMm,
      'type': type,
      'sportId': sportId,
      'itemCount': pendingItems.length,
      'createdAt': Timestamp.now(),
    });

    for (int i = 0; i < pendingItems.length; i++) {
      final pending = pendingItems[i];
      final imageUrl = await _uploadImage(pending);
      await _itemsCollection(docRef.id).add({
        'imageUrl': imageUrl,
        'descriptionEn': pending.descriptionEn,
        'descriptionMm': pending.descriptionMm,
        'stepOrder': i + 1,
        'stepNumber': pending.stepNumber,
        'poseLandmarks': pending.poseLandmarks ?? {},
        'poseAngles': pending.poseAngles ?? {},
      });
    }

    return docRef.id;
  }

  Future<void> updatePost({
    required String postId,
    required String titleEn,
    required String titleMm,
    required String type,
    required List<PendingExerciseStepItem> pendingItems,
  }) async {
    final oldItems = await _itemsCollection(postId).get();
    for (final doc in oldItems.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final oldUrl = data['imageUrl'] as String? ?? '';
      final stillUsed = pendingItems
          .any((p) => p.existingImageUrl == oldUrl && oldUrl.isNotEmpty);
      if (!stillUsed && oldUrl.isNotEmpty) {
        await ImageUploadService().deleteImage(oldUrl);
      }
      await doc.reference.delete();
    }

    for (int i = 0; i < pendingItems.length; i++) {
      final pending = pendingItems[i];
      final imageUrl = pending.imageBytes != null
          ? await _uploadImage(pending)
          : pending.existingImageUrl ?? '';
      await _itemsCollection(postId).add({
        'imageUrl': imageUrl,
        'descriptionEn': pending.descriptionEn,
        'descriptionMm': pending.descriptionMm,
        'stepOrder': i + 1,
        'stepNumber': pending.stepNumber,
        'poseLandmarks': pending.poseLandmarks ?? {},
        'poseAngles': pending.poseAngles ?? {},
      });
    }

    await _postsCollection.doc(postId).update({
      'titleEn': titleEn,
      'titleMm': titleMm,
      'type': type,
      'itemCount': pendingItems.length,
    });
  }

  Future<String> _uploadImage(PendingExerciseStepItem pending) async {
    final uploadService = ImageUploadService();
    return uploadService.uploadImage(
      bytes: pending.imageBytes!,
      fileName: pending.fileName ?? 'step.jpg',
      storagePath:
          'exercise_step_images/${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<void> deletePost(String postId) async {
    final items = await _itemsCollection(postId).get();
    for (final doc in items.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final imageUrl = data['imageUrl'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await ImageUploadService().deleteImage(imageUrl);
      }
      await doc.reference.delete();
    }
    await _postsCollection.doc(postId).delete();
  }
}

class PendingExerciseStepItem {
  final String? existingImageUrl;
  final Uint8List? imageBytes;
  final String? fileName;
  final String descriptionEn;
  final String descriptionMm;
  final int stepNumber;
  final Map<String, List<double>>? poseLandmarks;
  final Map<String, double>? poseAngles;

  PendingExerciseStepItem({
    this.existingImageUrl,
    this.imageBytes,
    this.fileName,
    required this.descriptionEn,
    required this.descriptionMm,
    this.stepNumber = 1,
    this.poseLandmarks,
    this.poseAngles,
  });
}
