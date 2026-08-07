import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/core/models/sport_detail_item.dart';

class SportDetailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> _normalizeSportData(Map<String, dynamic> data, String id) {
    final nameEn = (data['nameEn'] as String?)?.trim() ?? '';
    final nameMm = (data['nameMm'] as String?)?.trim() ?? '';
    final descriptionEn = (data['descriptionEn'] as String?)?.trim() ?? '';
    final descriptionMm = (data['descriptionMm'] as String?)?.trim() ?? '';
    final fallbackName = (data['name'] as String?)?.trim() ?? '';
    final fallbackDesc = (data['description'] as String?)?.trim() ?? '';
    return {
      ...data,
      'id': id,
      'nameEn': nameEn.isNotEmpty ? nameEn : fallbackName,
      'nameMm': nameMm.isNotEmpty ? nameMm : fallbackName,
      'descriptionEn': descriptionEn.isNotEmpty ? descriptionEn : fallbackDesc,
      'descriptionMm': descriptionMm.isNotEmpty ? descriptionMm : fallbackDesc,
    };
  }

  Stream<List<Map<String, dynamic>>> getSports() {
    return _firestore
        .collection('sports')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _normalizeSportData(doc.data(), doc.id))
            .toList());
  }

  Future<Map<String, dynamic>?> getSport(String sportId) async {
    final doc = await _firestore.collection('sports').doc(sportId).get();
    if (doc.exists) {
      return _normalizeSportData(doc.data()!, doc.id);
    }
    return null;
  }

  Stream<Map<String, dynamic>?> watchSport(String sportId) {
    return _firestore.collection('sports').doc(sportId).snapshots().map(
      (doc) {
        if (doc.exists) {
          return _normalizeSportData(doc.data()!, doc.id);
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
