import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/core/models/injury_item.dart';

class InjuryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _collection => _firestore.collection('injury_data');

  Stream<List<InjuryItem>> getItems(InjuryDataType type) {
    return _collection
        .where('type', isEqualTo: type.label.toLowerCase())
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs
          .map((doc) => InjuryItem.fromFirestore(doc))
          .toList();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }
}
