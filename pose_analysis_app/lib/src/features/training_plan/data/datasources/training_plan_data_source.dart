import 'package:ai_sports_training/src/features/training_plan/data/models/training_plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TrainingPlanDataSource {
  Future<List<TrainingPlanModel>> getUserTrainingPlans(String userId);
  Future<TrainingPlanModel?> getTrainingPlan(String planId);
  Future<void> createTrainingPlan(TrainingPlanModel plan);
  Future<void> updateTrainingPlan(TrainingPlanModel plan);
  Future<void> deleteTrainingPlan(String planId);
}

class FirestoreTrainingPlanDataSource implements TrainingPlanDataSource {
  final FirebaseFirestore firestore;

  FirestoreTrainingPlanDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<TrainingPlanModel>> getUserTrainingPlans(String userId) async {
    final snapshot = await firestore
        .collection('training_plans')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => TrainingPlanModel.fromFirestore(doc)).toList();
  }

  @override
  Future<TrainingPlanModel?> getTrainingPlan(String planId) async {
    final doc = await firestore.collection('training_plans').doc(planId).get();
    if (!doc.exists) return null;
    return TrainingPlanModel.fromFirestore(doc);
  }

  @override
  Future<void> createTrainingPlan(TrainingPlanModel plan) {
    return firestore.collection('training_plans').doc(plan.id).set(plan.toFirestore());
  }

  @override
  Future<void> updateTrainingPlan(TrainingPlanModel plan) {
    return firestore.collection('training_plans').doc(plan.id).update(plan.toFirestore());
  }

  @override
  Future<void> deleteTrainingPlan(String planId) {
    return firestore.collection('training_plans').doc(planId).delete();
  }
}