import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/training_plan/domain/entities/training_plan.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';

final trainingPlansProvider = FutureProvider.autoDispose<List<TrainingPlan>>((ref) async {
  return [
    TrainingPlan(
      id: '1',
      userId: 'user1',
      sportId: 'soccer',
      name: 'Beginner Soccer Training',
      description: 'Basic drills for beginners',
      durationWeeks: 4,
      sessions: [
        TrainingSession(
          id: '1',
          name: 'Day 1 - Basics',
          dayNumber: 1,
          exercises: [
            Exercise(id: '1', name: 'Juggling', sets: 3, reps: 10),
            Exercise(id: '2', name: 'Passing', sets: 4, reps: 20),
          ],
        ),
      ],
      createdAt: DateTime.now(),
    ),
  ];
});

class TrainingPlanPage extends ConsumerWidget {
  const TrainingPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(trainingPlansProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToMain(),
        ),
        title: const Text('Training Plans'),
      ),
      body: plansAsync.when(
        data: (plans) => ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(plan.name),
                subtitle: Text('${plan.durationWeeks} weeks'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}