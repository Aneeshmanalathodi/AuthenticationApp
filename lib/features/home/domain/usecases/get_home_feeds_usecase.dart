import '../entities/feed_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeFeedsUseCase {
  final HomeRepository repository;

  GetHomeFeedsUseCase(this.repository);

  Future<List<FeedEntity>> call() {
    return repository.getFeeds();
  }
}
