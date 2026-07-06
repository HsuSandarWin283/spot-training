import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';
import 'package:ai_sports_training/src/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailAndPassword implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignInWithEmailAndPassword(this.repository);

  @override
  Future<User> call(SignInParams params) {
    return repository.signInWithEmailAndPassword(params.email, params.password);
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams(this.email, this.password);
}

class SignUpWithEmailAndPassword implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpWithEmailAndPassword(this.repository);

  @override
  Future<User> call(SignUpParams params) {
    return repository.createUserWithEmailAndPassword(
      params.email,
      params.password,
      params.fullName,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String fullName;

  SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<void> call(NoParams params) {
    return repository.signOut();
  }
}

class ResetPassword implements UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPassword(this.repository);

  @override
  Future<void> call(ResetPasswordParams params) {
    return repository.sendPasswordResetEmail(params.email);
  }
}

class ResetPasswordParams {
  final String email;

  ResetPasswordParams(this.email);
}
