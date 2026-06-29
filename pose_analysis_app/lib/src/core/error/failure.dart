// ignore_for_file: use_super_parameters

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}

extension FailureX on Failure {
  bool get isAuthFailure => this is AuthFailure;
  bool get isNetworkFailure => this is NetworkFailure;
  bool get isServerFailure => this is ServerFailure;
  bool get isCacheFailure => this is CacheFailure;
  bool get isUnknownFailure => this is UnknownFailure;
}