import 'dart:io';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';
import '../models/feed_upload_response_model.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDatasource remote;

  FeedRepositoryImpl(this.remote);

  @override
  Future<FeedUploadResponseModel> uploadFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required Function(int, int) onSendProgress,
  }) async {

    final responseData = await remote.uploadFeed(
      video: video,
      image: image,
      desc: desc,
      category: category,
      onSendProgress: onSendProgress,
    );

    return FeedUploadResponseModel.fromJson(responseData);
  }

  @override
  Future<List<dynamic>> getMyFeeds() async {

    return await remote.getMyFeeds();
  }
}