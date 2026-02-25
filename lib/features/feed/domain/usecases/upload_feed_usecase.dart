import 'dart:io';
import '../repositories/feed_repository.dart';
import '../../data/models/feed_upload_response_model.dart';

class UploadFeedUsecase {
  final FeedRepository repository;

  UploadFeedUsecase(this.repository);

  Future<FeedUploadResponseModel> call({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required Function(int, int) onSendProgress,
  }) {
    return repository.uploadFeed(
      video: video,
      image: image,
      desc: desc,
      category: category,
      onSendProgress: onSendProgress,
    );
  }
}