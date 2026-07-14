import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_panel/src/core/services/image_upload_service.dart';

class SportModel {
  final String id;
  final String name;
  final String description;
  final String difficultyLevel;
  final String thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  SportModel({
    required this.id,
    required this.name,
    required this.description,
    required this.difficultyLevel,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SportModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      difficultyLevel: data['difficultyLevel'] ?? 'Beginner',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'difficultyLevel': difficultyLevel,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  SportModel copyWith({
    String? id,
    String? name,
    String? description,
    String? difficultyLevel,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SportModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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
    required String name,
    required String description,
    required String difficultyLevel,
    required String thumbnailUrl,
  }) async {
    final docRef = await _sportsCollection.add({
      'name': name,
      'description': description,
      'difficultyLevel': difficultyLevel,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });

    return docRef.id;
  }

  Future<void> updateSport({
    required String id,
    required String name,
    required String description,
    required String difficultyLevel,
    required String thumbnailUrl,
  }) async {
    await _sportsCollection.doc(id).update({
      'name': name,
      'description': description,
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

      int totalPoses = 0;
      for (final sportDoc in sportsSnapshot.docs) {
        final posesSnapshot = await sportDoc.reference.collection('poses').get();
        totalPoses += posesSnapshot.size;
      }

      if (!controller.isClosed) {
        controller.add({
          'totalSports': sportsSnapshot.size,
          'totalPoses': totalPoses,
          'totalExerciseStepImages': exerciseStepSnapshot.size,
          'totalUsers': usersSnapshot.size,
        });
      }
    }

    final subs = <StreamSubscription>[
      _sportsCollection.snapshots().listen((_) => computeAndEmit()),
      _firestore.collection('users').snapshots().listen((_) => computeAndEmit()),
      _firestore.collection('exercise_step_image_posts').snapshots().listen((_) => computeAndEmit()),
    ];

    controller.onCancel = () {
      for (final sub in subs) {
        sub.cancel();
      }
    };

    return controller.stream;
  }
}
