import 'package:authenticationapp/core/constants/app_colors.dart';
import 'package:authenticationapp/features/home/domain/entities/feed_entity.dart';
import 'package:authenticationapp/features/home/presentation/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/current_playing_provider.dart';

class FeedCard extends ConsumerWidget {
  final FeedEntity feed;
  final int index;

  const FeedCard({super.key, required this.feed, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.of(context).size.width;
    final currentPlaying = ref.watch(currentPlayingProvider);

    final isPlaying = currentPlaying == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage("https://picsum.photos/200"),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feed.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      feed.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isPlaying
                ? VideoPlayerWidget(url: feed.video)
                : GestureDetector(
                    onTap: () {
                      ref.read(currentPlayingProvider.notifier).state = index;
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          feed.image,
                          width: double.infinity,
                          height: w * 0.55,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, size: 28),
                        ),
                      ],
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              feed.description,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
