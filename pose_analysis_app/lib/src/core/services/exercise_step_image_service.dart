import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/core/models/exercise_step_image_post.dart';

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
}
