import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final videoPlayerProvider = FutureProvider.autoDispose
    .family<VideoPlayerController, String>((ref, url) async {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));

      await controller.initialize();

      controller.setLooping(false);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });
