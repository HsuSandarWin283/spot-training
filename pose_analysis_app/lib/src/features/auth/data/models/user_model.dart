import 'package:ai_sports_training/src/features/auth/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'photoUrl': photoUrl,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  User toDomain() => User(
        uid: uid,
        email: email,
        fullName: fullName,
        photoUrl: photoUrl,
        createdAt: createdAt,
      );

  UserModel copyWith({
    String? fullName,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }
}
