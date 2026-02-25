import 'package:authenticationapp/injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/feed_remote_datasource.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../../domain/usecases/upload_feed_usecase.dart';
import 'my_feed_provider.dart';

/// Upload progress provider
final uploadProgressProvider =
    StateProvider<double>((ref) => 0);

/// Upload Feed Usecase Provider
final uploadFeedUsecaseProvider =
    Provider<UploadFeedUsecase>((ref) {

  /// ✅ Get Dio from dioProvider
  final dio = ref.read(dioProvider);

  /// ✅ Pass Dio (NOT DioClient)
  final datasource =
      FeedRemoteDatasourceImpl(dio);

  final repo =
      FeedRepositoryImpl(datasource);

  return UploadFeedUsecase(repo);
});


/// Upload Feed Provider
final uploadFeedProvider =
    FutureProvider.family<void, Map<String, dynamic>>(
        (ref, data) async {

  final usecase =
      ref.read(uploadFeedUsecaseProvider);

  await usecase.call(
    video: data['video'],
    image: data['image'],
    desc: data['desc'],
    category: data['category'],

    onSendProgress: (sent, total) {

      if (total != 0) {
        ref.read(uploadProgressProvider.notifier)
            .state = sent / total;
      }

    },
  );

  ref.invalidate(myFeedProvider);
});