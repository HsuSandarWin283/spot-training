import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/home/data/models/sport_model.dart';

abstract class SportDataSource {
  Future<List<SportModel>> getAllSports();
  Future<SportModel?> getSportById(String id);
}

class FirestoreSportDataSource implements SportDataSource {
  final FirebaseFirestore firestore;

  FirestoreSportDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<SportModel>> getAllSports() async {
    final snapshot = await firestore.collection('sports').get();
    return snapshot.docs.map((doc) => SportModel.fromFirestore(doc)).toList();
  }

  @override
  Future<SportModel?> getSportById(String id) async {
    final doc = await firestore.collection('sports').doc(id).get();
    if (!doc.exists) return null;
    return SportModel.fromFirestore(doc);
  }
}