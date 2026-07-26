import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise_category.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/exercise.dart';
import 'package:ai_sports_training/src/features/exercise_flow/data/models/session_result.dart';

class ExerciseFlowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ExerciseCategory>> getCategories() {
    return _firestore
        .collection('exercise_categories')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExerciseCategory.fromFirestore(doc))
            .toList());
  }

  Stream<List<Exercise>> getExercisesByCategory(String categoryId) {
    return _firestore
        .collection('exercises')
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Exercise.fromFirestore(doc))
            .toList());
  }

  Future<Exercise?> getExercise(String exerciseId) async {
    final doc = await _firestore.collection('exercises').doc(exerciseId).get();
    if (doc.exists) {
      return Exercise.fromFirestore(doc);
    }
    return null;
  }

  Future<void> saveSessionResult(ExerciseSessionResult result) async {
    await _firestore.collection('exercise_sessions').add(result.toMap());
  }

  Stream<List<ExerciseSessionResult>> getUserSessions(String userId) {
    return _firestore
        .collection('exercise_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return ExerciseSessionResult(
                userId: data['userId'] ?? '',
                exerciseId: data['exerciseId'] ?? '',
                exerciseName: data['exerciseName'] ?? '',
                categoryId: data['categoryId'] ?? '',
                stepResults: (data['stepResults'] as List<dynamic>?)
                        ?.map((r) => StepResult(
                              stepNumber: r['stepNumber'] ?? 0,
                              accuracy: (r['accuracy'] ?? 0).toDouble(),
                              angleDifferences: Map<String, double>.from(
                                  r['angleDifferences'] ?? {}),
                              duration: Duration(
                                  seconds: r['durationSeconds'] ?? 0),
                              attemptCount: r['attemptCount'] ?? 1,
                            ))
                        .toList() ??
                    [],
                overallAccuracy: (data['overallAccuracy'] ?? 0).toDouble(),
                totalDuration:
                    Duration(seconds: data['totalDurationSeconds'] ?? 0),
                estimatedCalories: data['estimatedCalories'] ?? 0,
                completedAt:
                    (data['completedAt'] as Timestamp?)?.toDate() ??
                        DateTime.now(),
              );
            }).toList());
  }
}
