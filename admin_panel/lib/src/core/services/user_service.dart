import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');

  Stream<List<Map<String, dynamic>>> getUsers() {
    return _usersCollection.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => {'uid': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList());
  }

  Future<List<Map<String, dynamic>>> getUsersOnce() async {
    final snapshot = await _usersCollection.orderBy('createdAt', descending: true).get();
    return snapshot.docs
        .map((doc) => {'uid': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    await _usersCollection.doc(uid).update(updates);
  }

  Future<void> deleteUser(String uid) async {
    await _usersCollection.doc(uid).delete();
  }

  Future<int> getUserCount() async {
    final snapshot = await _usersCollection.get();
    return snapshot.size;
  }
}
