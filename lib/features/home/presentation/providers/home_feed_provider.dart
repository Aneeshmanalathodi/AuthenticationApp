
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/feed_entity.dart';
import '../../domain/usecases/get_home_feeds_usecase.dart';

final homeFeedProvider = FutureProvider<List<FeedEntity>>((ref) async {
  final dio = ref.watch(dioProvider);

  final dataSource = HomeRemoteDataSourceImpl(dio);
  final repository = HomeRepositoryImpl(dataSource);
  final usecase = GetHomeFeedsUseCase(repository);

  return await usecase();
});
