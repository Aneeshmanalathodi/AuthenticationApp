import 'dart:io';
import '../../data/models/feed_upload_response_model.dart';

abstract class FeedRepository {
  Future<FeedUploadResponseModel> uploadFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required Function(int, int) onSendProgress,
  });

  Future<List<dynamic>> getMyFeeds();
}
