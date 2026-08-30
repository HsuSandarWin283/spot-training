import 'package:cloud_firestore/cloud_firestore.dart';

class TypeCompletionCount {
  final String typeName;
  final int count;

  const TypeCompletionCount({required this.typeName, required this.count});
}

class IncompleteExercise {
  final String postId;
  final String titleEn;
  final String titleMm;
  final String type;
  final int completedItems;
  final int totalItems;

  const IncompleteExercise({
    required this.postId,
    required this.titleEn,
    required this.titleMm,
    required this.type,
    required this.completedItems,
    required this.totalItems,
  });

  int get remainingItems => totalItems - completedItems;

  String localizedTitle(String langCode) {
    if (langCode == 'my') return titleMm.isNotEmpty ? titleMm : titleEn;
    return titleEn.isNotEmpty ? titleEn : titleMm;
  }
}

class ExerciseCompletionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCompletion({
    required String userId,
    required String postId,
    required String postType,
  }) async {
    await _firestore.collection('user_exercise_completions').add({
      'userId': userId,
      'postId': postId,
      'postType': postType,
      'completedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Stream<List<TypeCompletionCount>> watchCompletionsByType(String userId) {
    return _firestore
        .collection('user_exercise_completions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return <TypeCompletionCount>[];

      final Map<String, int> grouped = {};
      for (final doc in snapshot.docs) {
        final type = (doc.data()['postType'] as String?) ?? 'Unknown';
        if (type.isEmpty) continue;
        grouped[type] = (grouped[type] ?? 0) + 1;
      }

      final list = grouped.entries
          .map((e) => TypeCompletionCount(typeName: e.key, count: e.value))
          .toList();
      list.sort((a, b) => b.count.compareTo(a.count));
      return list;
    });
  }

  Stream<List<IncompleteExercise>> watchCompletedExercises(String userId) {
    return _firestore
        .collection('user_exercise_completions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) return <IncompleteExercise>[];

      final Map<String, int> completedByPost = {};
      for (final doc in snapshot.docs) {
        final postId = (doc.data()['postId'] as String?) ?? '';
        if (postId.isEmpty) continue;
        completedByPost[postId] = (completedByPost[postId] ?? 0) + 1;
      }

      final List<IncompleteExercise> completed = [];
      for (final entry in completedByPost.entries) {
        final postDoc = await _firestore
            .collection('exercise_step_image_posts')
            .doc(entry.key)
            .get();
        if (!postDoc.exists) continue;
        final data = postDoc.data();
        if (data == null) continue;

        final itemCount = (data['itemCount'] as int?) ?? 0;
        if (entry.value < itemCount) continue;

        completed.add(IncompleteExercise(
          postId: entry.key,
          titleEn: data['titleEn'] ?? data['title'] ?? '',
          titleMm: data['titleMm'] ?? data['title'] ?? '',
          type: data['type'] ?? '',
          completedItems: entry.value,
          totalItems: itemCount,
        ));
      }

      completed.sort((a, b) => b.completedItems.compareTo(a.completedItems));
      return completed;
    });
  }

  Future<void> clearCompletionsForPost({
    required String userId,
    required String postId,
  }) async {
    final docs = await _firestore
        .collection('user_exercise_completions')
        .where('userId', isEqualTo: userId)
        .where('postId', isEqualTo: postId)
        .get();
    for (final doc in docs.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<IncompleteExercise>> watchIncompleteExercises(String userId) {
    return _firestore
        .collection('user_exercise_completions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) return <IncompleteExercise>[];

      final Map<String, int> completedByPost = {};
      for (final doc in snapshot.docs) {
        final postId = (doc.data()['postId'] as String?) ?? '';
        if (postId.isEmpty) continue;
        completedByPost[postId] = (completedByPost[postId] ?? 0) + 1;
      }

      final List<IncompleteExercise> incomplete = [];
      for (final entry in completedByPost.entries) {
        final postDoc = await _firestore
            .collection('exercise_step_image_posts')
            .doc(entry.key)
            .get();
        if (!postDoc.exists) continue;
        final data = postDoc.data();
        if (data == null) continue;

        final itemCount = (data['itemCount'] as int?) ?? 0;
        if (entry.value >= itemCount) continue;

        incomplete.add(IncompleteExercise(
          postId: entry.key,
          titleEn: data['titleEn'] ?? data['title'] ?? '',
          titleMm: data['titleMm'] ?? data['title'] ?? '',
          type: data['type'] ?? '',
          completedItems: entry.value,
          totalItems: itemCount,
        ));
      }

      incomplete.sort((a, b) => b.completedItems.compareTo(a.completedItems));
      return incomplete;
    });
  }
}
