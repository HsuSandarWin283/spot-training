import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/fitness_assessment.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/exercise_history.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/category_progress.dart';
import 'package:ai_sports_training/src/features/fitness_assessment/data/models/performance_report.dart';

class FitnessAssessmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> hasCompletedAssessment(String userId) async {
    final snapshot = await _firestore
        .collection('fitness_assessments')
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: true)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<FitnessAssessment?> getLatestAssessment(String userId) async {
    final snapshot = await _firestore
        .collection('fitness_assessments')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return FitnessAssessment.fromFirestore(snapshot.docs.first);
  }

  Stream<FitnessAssessment?> watchLatestAssessment(String userId) {
    return _firestore
        .collection('fitness_assessments')
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final list = snapshot.docs
          .map((doc) => FitnessAssessment.fromFirestore(doc))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list.first;
    });
  }

  Future<String> createAssessment(FitnessAssessment assessment) async {
    final docRef = await _firestore
        .collection('fitness_assessments')
        .add(assessment.toMap());
    return docRef.id;
  }

  Future<void> updateAssessment(FitnessAssessment assessment) async {
    await _firestore
        .collection('fitness_assessments')
        .doc(assessment.id)
        .update(assessment.toMap());
  }

  Future<void> completeAssessment(FitnessAssessment assessment) async {
    await _firestore
        .collection('fitness_assessments')
        .doc(assessment.id)
        .update({'isCompleted': true});
  }

  Future<void> saveExerciseHistory(ExerciseHistory history) async {
    await _firestore.collection('exercise_history').add(history.toMap());
  }

  Future<List<ExerciseHistory>> getExerciseHistory(String userId, {int limit = 50}) async {
    final snapshot = await _firestore
        .collection('exercise_history')
        .where('userId', isEqualTo: userId)
        .orderBy('completedAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => ExerciseHistory.fromFirestore(doc)).toList();
  }

  Future<List<CategoryProgress>> getCategoryProgress(String userId) async {
    final history = await getExerciseHistory(userId, limit: 500);
    if (history.isEmpty) return [];

    final Map<String, List<ExerciseHistory>> grouped = {};
    for (final h in history) {
      grouped.putIfAbsent(h.categoryId, () => []).add(h);
    }

    final List<CategoryProgress> progressList = [];
    for (final entry in grouped.entries) {
      final sessions = entry.value;
      sessions.sort((a, b) => a.completedAt.compareTo(b.completedAt));

      final totalSessions = sessions.length;
      final avgAccuracy = sessions.map((s) => s.accuracy).reduce((a, b) => a + b) / totalSessions;
      final totalCalories = sessions.map((s) => s.estimatedCalories).reduce((a, b) => a + b);

      double improvement = 0;
      if (sessions.length >= 2) {
        final recentAvg = sessions.skip(sessions.length ~/ 2).map((s) => s.accuracy).reduce((a, b) => a + b) / (sessions.length - sessions.length ~/ 2);
        final olderAvg = sessions.take(sessions.length ~/ 2).map((s) => s.accuracy).reduce((a, b) => a + b) / (sessions.length ~/ 2);
        if (olderAvg > 0) {
          improvement = ((recentAvg - olderAvg) / olderAvg) * 100;
        }
      }

      progressList.add(CategoryProgress(
        categoryId: entry.key,
        categoryName: sessions.first.categoryName,
        totalSessions: totalSessions,
        averageAccuracy: avgAccuracy,
        improvementPercentage: improvement,
        totalCaloriesBurned: totalCalories,
        lastSessionAt: sessions.last.completedAt,
      ));
    }

    progressList.sort((a, b) => (b.lastSessionAt ?? DateTime(0)).compareTo(a.lastSessionAt ?? DateTime(0)));
    return progressList;
  }

  Future<PerformanceReport> generatePerformanceReport(String userId) async {
    final assessment = await getLatestAssessment(userId);
    final history = await getExerciseHistory(userId, limit: 200);
    final categoryProgress = await getCategoryProgress(userId);

    double overallProgress = 0;
    final List<String> strengths = [];
    final List<String> areasToImprove = [];
    final List<String> recommended = [];

    if (history.isNotEmpty) {
      final avgAccuracy = history.map((h) => h.accuracy).reduce((a, b) => a + b) / history.length;
      overallProgress = avgAccuracy;

      if (avgAccuracy >= 80) {
        strengths.add('Excellent overall exercise form');
      } else if (avgAccuracy >= 60) {
        strengths.add('Good exercise consistency');
      } else {
        areasToImprove.add('Focus on improving exercise form');
      }

      if (history.length >= 5) {
        strengths.add('Consistent training habit');
      } else {
        areasToImprove.add('Exercise more regularly');
      }
    }

    if (categoryProgress.isNotEmpty) {
      for (final cat in categoryProgress) {
        if (cat.improvementPercentage > 5) {
          strengths.add('${cat.categoryName} accuracy improved by ${cat.improvementPercentage.toStringAsFixed(0)}%');
        } else if (cat.improvementPercentage < -5) {
          areasToImprove.add('${cat.categoryName} accuracy needs attention');
        }
      }
    }

    if (assessment != null) {
      if (assessment.overallScore < 50) {
        areasToImprove.add('Overall fitness needs improvement');
        recommended.add('Squats');
        recommended.add('Stretching');
        recommended.add('Balance Training');
      }
      if (assessment.fitnessLevel == FitnessLevel.beginner) {
        areasToImprove.add('Build a consistent exercise routine');
        recommended.add('Walking');
        recommended.add('Basic Stretches');
      }
    }

    if (recommended.isEmpty) {
      recommended.addAll(['Squats', 'Stretching', 'Balance Training']);
    }

    String feedbackSummary = '';
    if (history.isNotEmpty) {
      final recentSessions = history.take(10).toList();
      final recentAvg = recentSessions.map((s) => s.accuracy).reduce((a, b) => a + b) / recentSessions.length;
      if (recentAvg >= 85) {
        feedbackSummary = 'Outstanding performance! You are excelling in your training.';
      } else if (recentAvg >= 70) {
        feedbackSummary = 'Good progress! Keep pushing yourself to reach the next level.';
      } else if (recentAvg >= 50) {
        feedbackSummary = 'Steady improvement. Focus on form and consistency.';
      } else {
        feedbackSummary = 'Keep practicing! Consistency is key to improvement.';
      }
    } else {
      feedbackSummary = 'Start your fitness journey by completing exercises!';
    }

    double? strengthImprove, flexImprove, balanceImprove, coordImprove, overallImprove;
    if (assessment != null && history.length >= 10) {
      final recentAvg = history.take(10).map((h) => h.accuracy).reduce((a, b) => a + b) / 10;
      final initialScore = assessment.overallScore;
      overallImprove = recentAvg - initialScore;
      strengthImprove = recentAvg - initialScore;
    }

    return PerformanceReport(
      overallProgressPercentage: overallProgress,
      fitnessLevel: assessment?.fitnessLevel?.toString().split('.').last ?? 'beginner',
      strengths: strengths,
      areasToImprove: areasToImprove,
      recommendedExercises: recommended,
      summaryFeedback: feedbackSummary,
      strengthImprovement: strengthImprove,
      flexibilityImprovement: flexImprove,
      balanceImprovement: balanceImprove,
      coordinationImprovement: coordImprove,
      overallImprovement: overallImprove,
    );
  }
}
