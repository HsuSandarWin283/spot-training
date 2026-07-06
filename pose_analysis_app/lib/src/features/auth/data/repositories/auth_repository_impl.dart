import 'package:ai_sports_training/src/features/auth/data/datasources/auth_data_source.dart';
import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';
import 'package:ai_sports_training/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User?> getCurrentUser() async {
    final result = await dataSource.getCurrentUser();
    return result?.toDomain();
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final result = await dataSource.signIn(email, password);
    return result.toDomain();
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password, String fullName) async {
    final result = await dataSource.signUp(email, password, fullName);
    return result.toDomain();
  }

  @override
  Future<void> signOut() => dataSource.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) => dataSource.resetPassword(email);

  @override
  Future<void> updateProfile({String? fullName, String? photoUrl}) =>
      dataSource.updateProfile(fullName: fullName, photoUrl: photoUrl);

  @override
  Stream<User?> get authStateChanges => dataSource.authStateChanges.map((model) => model?.toDomain());
}
