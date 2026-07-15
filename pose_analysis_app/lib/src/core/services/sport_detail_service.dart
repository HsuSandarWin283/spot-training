import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/core/models/sport_detail_item.dart';

class SportDetailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getSports() {
    return _firestore
        .collection('sports')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  Future<Map<String, dynamic>?> getSport(String sportId) async {
    final doc = await _firestore.collection('sports').doc(sportId).get();
    if (doc.exists) {
      return {'id': doc.id, ...doc.data()!};
    }
    return null;
  }

  Stream<Map<String, dynamic>?> watchSport(String sportId) {
    return _firestore.collection('sports').doc(sportId).snapshots().map(
      (doc) {
        if (doc.exists) {
          return {'id': doc.id, ...doc.data()!};
        }
        return null;
      },
    );
  }

  Stream<List<SportDetailItem>> getItems(String sportId, SportDetailType type) {
    return _firestore
        .collection(type.collectionName)
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
}
