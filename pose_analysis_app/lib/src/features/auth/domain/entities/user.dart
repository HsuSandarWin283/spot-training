import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String fullName;
  final String? photoUrl;
  final DateTime createdAt;

  const User({
    required this.uid,
    required this.email,
    required this.fullName,
    this.photoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, fullName, photoUrl, createdAt];
}
