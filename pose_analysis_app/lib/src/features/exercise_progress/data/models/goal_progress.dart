import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseProgressEntry {
  final String userId;
  final String goal;
  final String poseName;
  final int successCount;
  final DateTime lastCompletedAt;
  final double averageAccuracy;

  const ExerciseProgressEntry({
    required this.userId,
    required this.goal,
    required this.poseName,
    required this.successCount,
    required this.lastCompletedAt,
    required this.averageAccuracy,
  });

  factory ExerciseProgressEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseProgressEntry(
      userId: data['userId'] ?? '',
      goal: data['goal'] ?? '',
      poseName: data['poseName'] ?? '',
      successCount: data['successCount'] ?? 0,
      lastCompletedAt:
          (data['lastCompletedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      averageAccuracy: (data['averageAccuracy'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'goal': goal,
      'poseName': poseName,
      'successCount': successCount,
      'lastCompletedAt': Timestamp.fromDate(lastCompletedAt),
      'averageAccuracy': averageAccuracy,
    };
  }
}

class GoalProgress {
  final String goal;
  final int totalSessions;
  final int totalSuccesses;
  final double averageAccuracy;
  final List<ExerciseProgressEntry> poses;

  const GoalProgress({
    required this.goal,
    required this.totalSessions,
    required this.totalSuccesses,
    required this.averageAccuracy,
    required this.poses,
  });

  String get feedback {
    if (totalSuccesses >= 20) return 'Excellent progress!';
    if (totalSuccesses >= 10) return 'Improving steadily.';
    if (totalSuccesses >= 5) return 'Good start, keep going!';
    return 'Needs more practice.';
  }

  String get nextRecommendation {
    if (poses.isEmpty) return 'Start with basic exercises.';
    final sorted = List<ExerciseProgressEntry>.from(poses)
      ..sort((a, b) => a.successCount.compareTo(b.successCount));
    final weakest = sorted.first;
    if (weakest.successCount < 5) {
      return 'Practice ${weakest.poseName} more.';
    }
    return 'Try a new exercise variation.';
  }
}
