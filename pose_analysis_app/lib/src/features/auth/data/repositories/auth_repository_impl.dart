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
  Future<User> createUserWithEmailAndPassword(String email, String password, String displayName) async {
    final result = await dataSource.signUp(email, password, displayName);
    return result.toDomain();
  }

  @override
  Future<void> signOut() => dataSource.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) => dataSource.resetPassword(email);

  @override
  Stream<User?> get userChanges => dataSource.userChanges.map((model) => model?.toDomain());
}