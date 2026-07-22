import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String? phone;
  final String? bio;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.phone,
    this.bio,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      phone: data['phone'],
      bio: data['bio'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'photoUrl': photoUrl,
        'phone': phone,
        'bio': bio,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  User toDomain() => User(
        uid: uid,
        email: email,
        fullName: fullName,
        photoUrl: photoUrl,
        phone: phone,
        bio: bio,
        createdAt: createdAt,
      );

  UserModel copyWith({
    String? fullName,
    String? photoUrl,
    String? phone,
    String? bio,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      createdAt: createdAt,
    );
  }
}
