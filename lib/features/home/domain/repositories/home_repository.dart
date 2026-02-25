import '../entities/category_entity.dart';
import '../entities/feed_entity.dart';

abstract class HomeRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<FeedEntity>> getFeeds();
}
