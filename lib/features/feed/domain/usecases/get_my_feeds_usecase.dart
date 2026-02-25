import '../repositories/feed_repository.dart';

class GetMyFeedsUsecase {
  final FeedRepository repository;

  GetMyFeedsUsecase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getMyFeeds();
  }
}