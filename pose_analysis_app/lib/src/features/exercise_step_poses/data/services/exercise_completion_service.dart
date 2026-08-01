import 'package:cloud_firestore/cloud_firestore.dart';

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
}
