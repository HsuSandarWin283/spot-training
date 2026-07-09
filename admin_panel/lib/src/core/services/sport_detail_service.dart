import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/src/core/models/sport_detail_models.dart';

class SportDetailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _collection(SportDetailType type) =>
      _firestore.collection(type.collectionName);

  Stream<List<SportDetailItem>> getItems(String sportId, SportDetailType type) {
    return _collection(type)
        .where('sportId', isEqualTo: sportId)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs
          .map((doc) => SportDetailItem.fromFirestore(doc))
          .toList();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }

  Future<SportDetailItem?> getItem(String id, SportDetailType type) async {
    final doc = await _collection(type).doc(id).get();
    if (doc.exists) {
      return SportDetailItem.fromFirestore(doc);
    }
    return null;
  }

  Future<String> addItem({
    required String sportId,
    required String title,
    required String description,
    required SportDetailType type,
  }) async {
    final docRef = await _collection(type).add({
      'sportId': sportId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.now(),
    });
    return docRef.id;
  }

  Future<void> updateItem({
    required String id,
    required String title,
    required String description,
    required SportDetailType type,
  }) async {
    await _collection(type).doc(id).update({
      'title': title,
      'description': description,
    });
  }

  Future<void> deleteItem(String id, SportDetailType type) async {
    await _collection(type).doc(id).delete();
  }
}
