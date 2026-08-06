import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/src/core/models/injury_item.dart';

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

  Future<InjuryItem?> getItem(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return InjuryItem.fromFirestore(doc);
    }
    return null;
  }

  Future<String> addItem({
    required InjuryDataType type,
    required String title,
    required String description,
    String imageUrl = '',
  }) async {
    final docRef = await _collection.add({
      'type': type.label.toLowerCase(),
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
    return docRef.id;
  }

  Future<void> updateItem({
    required String id,
    required InjuryDataType type,
    required String title,
    required String description,
    String imageUrl = '',
  }) async {
    await _collection.doc(id).update({
      'type': type.label.toLowerCase(),
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    });
  }

  Future<void> deleteItem(String id) async {
    await _collection.doc(id).delete();
  }
}
