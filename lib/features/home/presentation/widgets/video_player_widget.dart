import 'package:authenticationapp/features/home/presentation/widgets/fullscreen_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../providers/video_player_provider.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  bool _showControls = true;
  VideoPlayerController? _savedController;

  @override
  void initState() {
    super.initState();
    _savedController = null;
  }

  @override
  void dispose() {
    if (_savedController != null) {
      _savedController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(videoPlayerProvider(widget.url));

    return controllerAsync.when(
      data: (controller) {
        _savedController = controller;

        return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(controller),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                },
              ),

              if (_showControls) _buildControls(controller),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text("Video Error")),
    );
  }

  Widget _buildControls(VideoPlayerController controller) {
    final position = controller.value.position;
    final duration = controller.value.duration;

    return Container(
      color: Colors.black38,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.red,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.white24,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              IconButton(
                icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  });
                },
              ),

              Text(
                _format(position),
                style: const TextStyle(color: Colors.white),
              ),

              const Text(" / ", style: TextStyle(color: Colors.white)),

              Text(
                _format(duration),
                style: const TextStyle(color: Colors.white),
              ),

              const Spacer(),

              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenVideo(controller: controller),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
