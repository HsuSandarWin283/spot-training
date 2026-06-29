import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_sports_training/src/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String displayName);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<UserModel?> get userChanges;
}

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    final doc = await firestore.collection('users').doc(user.uid).get();
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    final doc = await firestore.collection('users').doc(user.uid).get();
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<UserModel> signUp(String email, String password, String displayName) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    final userModel = UserModel(
      id: user.uid,
      email: email,
      displayName: displayName,
      photoUrl: user.photoURL,
    );
    await firestore.collection('users').doc(user.uid).set(userModel.toFirestore());
    return userModel;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Stream<UserModel?> get userChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
      return UserModel.fromFirestore(doc);
    });
  }
}