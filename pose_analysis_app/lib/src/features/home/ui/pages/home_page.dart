import 'package:ai_sports_training/src/core/usecase/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_sports_training/src/features/home/data/sport_provider.dart';
import 'package:ai_sports_training/src/features/home/domain/usecases/sport_usecases.dart';
import 'package:ai_sports_training/src/features/home/domain/entities/sport.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';

final sportsListProvider = FutureProvider.autoDispose<List<Sport>>((ref) async {
  final useCase = GetAllSports(ref.read(sportRepositoryProvider));
  return useCase(NoParams());
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportsAsync = ref.watch(sportsListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToMain(),
        ),
        title: const Text('Sports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.goToSettings(),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.goToProfile(),
          ),
        ],
      ),
      body: sportsAsync.when(
        data: (sports) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: sports.length,
          itemBuilder: (context, index) => SportCard(sport: sports[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class SportCard extends StatelessWidget {
  final Sport sport;

  const SportCard({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: sport.imageUrl.isNotEmpty
                  ? Image.network(
                      sport.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image, size: 50)),
                    )
                  : const Center(child: Icon(Icons.sports, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                sport.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}