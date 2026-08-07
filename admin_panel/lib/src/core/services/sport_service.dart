import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_panel/src/core/services/image_upload_service.dart';

class SportModel {
  final String id;
  final String nameEn;
  final String nameMm;
  final String descriptionEn;
  final String descriptionMm;
  final String difficultyLevel;
  final String thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  SportModel({
    required this.id,
    required this.nameEn,
    required this.nameMm,
    required this.descriptionEn,
    required this.descriptionMm,
    required this.difficultyLevel,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final nameEn = data['nameEn'] ?? data['name'] ?? '';
    final nameMm = data['nameMm'] ?? data['name'] ?? '';
    final descriptionEn = data['descriptionEn'] ?? data['description'] ?? '';
    final descriptionMm = data['descriptionMm'] ?? data['description'] ?? '';
    return SportModel(
      id: doc.id,
      nameEn: nameEn,
      nameMm: nameMm,
      descriptionEn: descriptionEn,
      descriptionMm: descriptionMm,
      difficultyLevel: data['difficultyLevel'] ?? 'Beginner',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameEn': nameEn,
      'nameMm': nameMm,
      'descriptionEn': descriptionEn,
      'descriptionMm': descriptionMm,
      'difficultyLevel': difficultyLevel,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  SportModel copyWith({
    String? id,
    String? nameEn,
    String? nameMm,
    String? descriptionEn,
    String? descriptionMm,
    String? difficultyLevel,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SportModel(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameMm: nameMm ?? this.nameMm,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionMm: descriptionMm ?? this.descriptionMm,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String localizedName(String languageCode) {
    if (languageCode == 'my') return nameMm.isNotEmpty ? nameMm : nameEn;
    return nameEn.isNotEmpty ? nameEn : nameMm;
  }

  String localizedDescription(String languageCode) {
    if (languageCode == 'my') return descriptionMm.isNotEmpty ? descriptionMm : descriptionEn;
    return descriptionEn.isNotEmpty ? descriptionEn : descriptionMm;
  }

  String get name => nameEn;
  String get description => descriptionEn;
}

class SportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _sportsCollection => _firestore.collection('sports');

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<void> updateAdminProfile({
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }
    if (email != null && email.isNotEmpty && email != user.email) {
      await user.verifyBeforeUpdateEmail(email);
    }
    if (photoUrl != null) {
      await user.updatePhotoURL(photoUrl);
    }
    final updates = <String, dynamic>{};
    if (displayName != null) updates['fullName'] = displayName;
    if (email != null && email.isNotEmpty) updates['email'] = email;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;
    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).set(updates, SetOptions(merge: true));
    }
  }

  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updatePassword(newPassword);
  }

  Stream<List<SportModel>> getSports() {
    return _sportsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SportModel.fromFirestore(doc))
            .toList());
  }

  Future<SportModel?> getSport(String id) async {
    final doc = await _sportsCollection.doc(id).get();
    if (doc.exists) {
      return SportModel.fromFirestore(doc);
    }
    return null;
  }

  Future<String> addSport({
    required String nameEn,
    required String nameMm,
    required String descriptionEn,
    required String descriptionMm,
    required String difficultyLevel,
    required String thumbnailUrl,
  }) async {
    final docRef = await _sportsCollection.add({
      'nameEn': nameEn,
      'nameMm': nameMm,
      'descriptionEn': descriptionEn,
      'descriptionMm': descriptionMm,
      'difficultyLevel': difficultyLevel,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });

    return docRef.id;
  }

  Future<void> updateSport({
    required String id,
    required String nameEn,
    required String nameMm,
    required String descriptionEn,
    required String descriptionMm,
    required String difficultyLevel,
    required String thumbnailUrl,
  }) async {
    await _sportsCollection.doc(id).update({
      'nameEn': nameEn,
      'nameMm': nameMm,
      'descriptionEn': descriptionEn,
      'descriptionMm': descriptionMm,
      'difficultyLevel': difficultyLevel,
      'thumbnailUrl': thumbnailUrl,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteSport(String id) async {
    final doc = await _sportsCollection.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final thumbnailUrl = data['thumbnailUrl'] as String?;
      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
        await ImageUploadService().deleteImage(thumbnailUrl);
      }
      await _sportsCollection.doc(id).delete();
    }
  }

  Stream<Map<String, int>> getDashboardStats() {
    final controller = StreamController<Map<String, int>>();

    Future<void> computeAndEmit() async {
      final sportsSnapshot = await _sportsCollection.get();
      final usersSnapshot = await _firestore.collection('users').get();
      final exerciseStepSnapshot =
          await _firestore.collection('exercise_step_image_posts').get();
      final injurySnapshot = await _firestore.collection('injury_data').get();

      int totalInjuryPreventions = 0;
      int totalInjuryTreatments = 0;
      for (final doc in injurySnapshot.docs) {
        final type = doc['type'] as String? ?? '';
        if (type == 'prevention') {
          totalInjuryPreventions++;
        } else if (type == 'treatment') {
          totalInjuryTreatments++;
        }
      }

      if (!controller.isClosed) {
        controller.add({
          'totalSports': sportsSnapshot.size,
          'totalExerciseStepImages': exerciseStepSnapshot.size,
          'totalUsers': usersSnapshot.size,
          'totalInjuryPreventions': totalInjuryPreventions,
          'totalInjuryTreatments': totalInjuryTreatments,
        });
      }
    }

    final subs = <StreamSubscription>[
      _sportsCollection.snapshots().listen((_) => computeAndEmit()),
      _firestore.collection('users').snapshots().listen((_) => computeAndEmit()),
      _firestore.collection('exercise_step_image_posts').snapshots().listen((_) => computeAndEmit()),
      _firestore.collection('injury_data').snapshots().listen((_) => computeAndEmit()),
    ];

    controller.onCancel = () {
      for (final sub in subs) {
        sub.cancel();
      }
    };

    return controller.stream;
  }
}
