import 'package:flutter/material.dart';

class UploadProgressWidget extends StatelessWidget {
  final double progress;

  const UploadProgressWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress == 0) return const SizedBox();

    return Column(
      children: [
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 6),
        Text("${(progress * 100).toStringAsFixed(0)} %"),
      ],
    );
  }
}