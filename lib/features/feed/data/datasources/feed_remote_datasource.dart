import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class FeedRemoteDatasource {
  Future<Map<String, dynamic>> uploadFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required ProgressCallback onSendProgress,
  });

  Future<List<dynamic>> getMyFeeds();
}

class FeedRemoteDatasourceImpl implements FeedRemoteDatasource {
  final Dio dio;

  FeedRemoteDatasourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> uploadFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required ProgressCallback onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(video.path),
        "image": await MultipartFile.fromFile(image.path),
        "desc": desc,
        "category": category,
      });

      final response = await dio.post(
        ApiConstants.myFeed,
        data: formData,
        onSendProgress: onSendProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        if (response.data["status"] == true) {
          return response.data;
        } else {
          throw ServerException(response.data["message"] ?? "Upload failed");
        }
      } else {
        throw ServerException("Upload failed");
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?["message"] ?? e.message ?? "Server error",
      );
    }
  }

  @override
Future<List<dynamic>> getMyFeeds() async {
  try {
    final response = await dio.get(ApiConstants.myFeed);

    if (response.statusCode == 200) {

      final responseData = response.data;

      final results = responseData["results"];

      if (results is List) {
        return results;
      } else {
        return [];
      }

    } else {
      throw ServerException("Failed to fetch feeds");
    }
  } on DioException catch (e) {
    throw ServerException(
      e.response?.data?["detail"] ??
      e.response?.data?["message"] ??
      e.message ??
      "Server error",
    );
  }
}

}






