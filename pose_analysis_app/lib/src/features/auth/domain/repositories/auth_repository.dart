import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password, String fullName);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updateProfile({String? fullName, String? photoUrl});
  Stream<User?> get authStateChanges;
}
