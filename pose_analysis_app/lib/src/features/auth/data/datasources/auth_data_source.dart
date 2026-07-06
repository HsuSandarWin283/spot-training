import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String fullName);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> updateProfile({String? fullName, String? photoUrl});
  Stream<UserModel?> get authStateChanges;
}

class FirebaseAuthDataSource implements AuthDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    final doc = await _users.doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fbUser = credential.user!;
    final doc = await _users.doc(fbUser.uid).get();
    if (!doc.exists) {
      final fallbackName = fbUser.displayName?.isNotEmpty == true
          ? fbUser.displayName!
          : email.split('@').first;
      final userModel = UserModel(
        uid: fbUser.uid,
        email: email,
        fullName: fallbackName,
        photoUrl: fbUser.photoURL,
        createdAt: DateTime.now(),
      );
      await _users.doc(fbUser.uid).set(userModel.toFirestore());
      return userModel;
    }
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<UserModel> signUp(String email, String password, String fullName) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fbUser = credential.user!;
    await fbUser.updateDisplayName(fullName);
    final userModel = UserModel(
      uid: fbUser.uid,
      email: email,
      fullName: fullName,
      photoUrl: fbUser.photoURL,
      createdAt: DateTime.now(),
    );
    await _users.doc(fbUser.uid).set(userModel.toFirestore());
    return userModel;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updateProfile({String? fullName, String? photoUrl}) async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) return;

    final updates = <String, dynamic>{};
    if (fullName != null) {
      await fbUser.updateDisplayName(fullName);
      updates['fullName'] = fullName;
    }
    if (photoUrl != null) {
      await fbUser.updatePhotoURL(photoUrl);
      updates['photoUrl'] = photoUrl;
    }
    if (updates.isNotEmpty) {
      await _users.doc(fbUser.uid).update(updates);
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      final doc = await _users.doc(fbUser.uid).get();
      if (!doc.exists) {
        final fallbackName = fbUser.displayName?.isNotEmpty == true
            ? fbUser.displayName!
            : (fbUser.email ?? '').split('@').first;
        final userModel = UserModel(
          uid: fbUser.uid,
          email: fbUser.email ?? '',
          fullName: fallbackName,
          photoUrl: fbUser.photoURL,
          createdAt: DateTime.now(),
        );
        await _users.doc(fbUser.uid).set(userModel.toFirestore());
        return userModel;
      }
      final model = UserModel.fromFirestore(doc);
      if (model.fullName.isEmpty) {
        final fallbackName = fbUser.displayName?.isNotEmpty == true
            ? fbUser.displayName!
            : (fbUser.email ?? '').split('@').first;
        await _users.doc(fbUser.uid).update({'fullName': fallbackName});
        return model.copyWith(fullName: fallbackName);
      }
      return model;
    });
  }
}
