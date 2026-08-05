import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/exercise_progress/data/models/goal_progress.dart';

class ExerciseProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _getCategoryName(String categoryId) async {
    if (categoryId.isEmpty) return 'General';
    try {
      final doc = await _firestore
          .collection('exercise_categories')
          .doc(categoryId)
          .get();
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['name'] ?? 'General';
      }
    } catch (_) {}
    return 'General';
  }

  Stream<List<ExerciseProgressEntry>> watchUserProgress(String userId) {
    return _firestore
        .collection('exercise_history')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) return <ExerciseProgressEntry>[];

      final Map<String, List<Map<String, dynamic>>> grouped = {};
      final Map<String, String> categoryCache = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        var goal = (data['categoryName'] as String?) ?? '';
        final categoryId = (data['categoryId'] as String?) ?? '';

        if (goal.isEmpty && categoryId.isNotEmpty) {
          if (categoryCache.containsKey(categoryId)) {
            goal = categoryCache[categoryId]!;
          } else {
            goal = await _getCategoryName(categoryId);
            categoryCache[categoryId] = goal;
          }
        }
        if (goal.isEmpty) goal = 'General';

        final poseName = (data['exerciseName'] as String?) ?? 'Exercise';
        final key = '$goal|$poseName';
        grouped.putIfAbsent(key, () => []).add(data);
      }

      final List<ExerciseProgressEntry> results = [];
      for (final entry in grouped.entries) {
        final parts = entry.key.split('|');
        final goal = parts[0];
        final poseName = parts[1];
        final records = entry.value;

        final successCount = records.length;
        final avgAccuracy = records
                .map((r) => (r['accuracy'] ?? 0).toDouble())
                .reduce((a, b) => a + b) /
            records.length;
        final lastDate = records
            .map((r) =>
                (r['completedAt'] as Timestamp?)?.toDate() ?? DateTime(0))
            .reduce((a, b) => a.isAfter(b) ? a : b);

        results.add(ExerciseProgressEntry(
          userId: userId,
          goal: goal,
          poseName: poseName,
          successCount: successCount,
          lastCompletedAt: lastDate,
          averageAccuracy: avgAccuracy,
        ));
      }

      return results;
    });
  }

  Stream<List<GoalProgress>> watchGoalProgressList(String userId) {
    return watchUserProgress(userId).map((entries) {
      if (entries.isEmpty) return <GoalProgress>[];

      final Map<String, List<ExerciseProgressEntry>> grouped = {};
      for (final entry in entries) {
        grouped.putIfAbsent(entry.goal, () => []).add(entry);
      }

      final List<GoalProgress> goals = [];
      for (final entry in grouped.entries) {
        final poses = entry.value;
        final totalSessions = poses.fold(0, (sum, p) => sum + p.successCount);
        final avgAccuracy =
            poses.fold(0.0, (sum, p) => sum + p.averageAccuracy) /
                poses.length;

        goals.add(GoalProgress(
          goal: entry.key,
          totalSessions: totalSessions,
          totalSuccesses: totalSessions,
          averageAccuracy: avgAccuracy,
          poses: poses,
        ));
      }

      goals.sort((a, b) => b.totalSessions.compareTo(a.totalSessions));
      return goals;
    });
  }

  Stream<List<ExerciseProgressEntry>> watchRecommendations(String userId) {
    return watchUserProgress(userId).map((entries) {
      if (entries.isEmpty) return <ExerciseProgressEntry>[];
      entries.sort((a, b) => a.successCount.compareTo(b.successCount));
      return entries.take(5).toList();
    });
  }
}
