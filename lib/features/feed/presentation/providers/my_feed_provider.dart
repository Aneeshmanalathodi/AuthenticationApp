import 'package:authenticationapp/injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authenticationapp/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:authenticationapp/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:authenticationapp/features/feed/domain/usecases/get_my_feeds_usecase.dart';

final myFeedProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.read(dioProvider); 

  final datasource = FeedRemoteDatasourceImpl(dio);  
  final repo = FeedRepositoryImpl(datasource);
  final usecase = GetMyFeedsUsecase(repo);

  return usecase.call();
});



