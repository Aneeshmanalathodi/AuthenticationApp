import '../error/exceptions.dart';
import '../constants/app_constants.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class Validators {
  Validators._();

  static void validatePhone(String phone) {
    if (phone.isEmpty || phone.length != 10) {
      throw ValidationException("Invalid phone number");
    }
  }

  static void validateDescription(String desc) {
    if (desc.trim().isEmpty) {
      throw ValidationException("Description is required");
    }
  }

  static void validateCategories(List<int> categories) {
    if (categories.isEmpty) {
      throw ValidationException("Select at least one category");
    }
  }

  static Future<void> validateVideo(File video) async {
    if (!video.path.endsWith(".mp4")) {
      throw ValidationException("Only MP4 videos allowed");
    }

    final controller = VideoPlayerController.file(video);
    await controller.initialize();

    final duration = controller.value.duration.inMinutes;

    if (duration > AppConstants.maxVideoDurationMinutes) {
      throw ValidationException(
          "Video must be under ${AppConstants.maxVideoDurationMinutes} minutes");
    }

    await controller.dispose();
  }
}