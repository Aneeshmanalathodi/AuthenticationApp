import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/feed_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<FeedModel>> getFeeds();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(
        ApiConstants.categoryList,
        options: Options(headers: {"Accept": "application/json"}),
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        if (response.data['status'] == true) {
          final List list = response.data['categories'];

          return list.map((e) => CategoryModel.fromJson(e)).toList();
        } else {
          throw ServerException("Category status false");
        }
      } else {
        throw ServerException("Failed to load categories");
      }
    } catch (e) {
      throw ServerException("Category API error: ${e.toString()}");
    }
  }

  @override
  Future<List<FeedModel>> getFeeds() async {
    try {
      final response = await dio.get(
        ApiConstants.home,
        options: Options(headers: {"Accept": "application/json"}),
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        final List list = response.data['results'];

        return list.map((e) => FeedModel.fromJson(e)).toList();
      } else {
        throw ServerException("Failed to load feeds");
      }
    } catch (e) {
      throw ServerException("Feed API error: ${e.toString()}");
    }
  }
}
