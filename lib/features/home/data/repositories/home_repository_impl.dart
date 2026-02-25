import '../../domain/entities/category_entity.dart';
import '../../domain/entities/feed_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() {
    return remoteDataSource.getCategories();
  }

  @override
  Future<List<FeedEntity>> getFeeds() {
    return remoteDataSource.getFeeds();
  }
}
