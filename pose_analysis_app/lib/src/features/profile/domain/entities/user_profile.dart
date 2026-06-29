import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int age;
  final double weight;
  final double height;
  final List<String> favoriteSports;

  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.age = 0,
    this.weight = 0,
    this.height = 0,
    this.favoriteSports = const [],
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        age,
        weight,
        height,
        favoriteSports,
      ];
}