import 'package:cloud_firestore/cloud_firestore.dart';

class TypeCompletionCount {
  final String typeName;
  final int count;

  const TypeCompletionCount({required this.typeName, required this.count});
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
}
