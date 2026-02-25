import 'package:authenticationapp/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/my_feed_provider.dart';

class MyFeedScreen extends ConsumerWidget {
  const MyFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(myFeedProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
          },
        ),
        title: const Text(
          "My Feeds",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.invalidate(myFeedProvider);
            },
          ),
        ],
      ),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(
          child: Text(
            "Something went wrong\n${error.toString()}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),

        data: (feeds) {
          if (feeds.isEmpty) {
            return const Center(
              child: Text("No feeds found", style: TextStyle(fontSize: 16)),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myFeedProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                final item = feeds[index] as Map<String, dynamic>;

                final image = item['image']?.toString() ?? "";

                final description = item['description']?.toString() ?? "";

                final createdAt = item['created_at']?.toString() ?? "";

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (image.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),

                        const SizedBox(height: 8),

                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 6),

                        if (createdAt.isNotEmpty)
                          Text(
                            createdAt,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
