import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String? phone;
  final String? bio;
  final DateTime createdAt;

  const User({
    required this.uid,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.phone,
    this.bio,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, fullName, photoUrl, phone, bio, createdAt];
}
