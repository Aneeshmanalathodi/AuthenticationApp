import 'package:authenticationapp/features/feed/presentation/screens/add_feed_screen.dart';
import 'package:authenticationapp/features/home/presentation/providers/category_provider.dart';
import 'package:authenticationapp/features/home/presentation/providers/home_feed_provider.dart';
import 'package:authenticationapp/features/home/presentation/widgets/category_chip.dart';
import 'package:authenticationapp/features/home/presentation/widgets/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final feedsAsync = ref.watch(homeFeedProvider);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFeedScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Maria",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Welcome back to Section",
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage("https://picsum.photos/300"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            categoriesAsync.when(
              data: (categories) {
                return SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryChip(categories[index].name, index == 0);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text(
                "Failed to load categories",
                style: TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(height: 24),

            feedsAsync.when(
              data: (feeds) {
                return Column(
                  children: List.generate(
                    feeds.length,
                    (index) => FeedCard(feed: feeds[index], index: index),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text(
                "Failed to load feeds",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
