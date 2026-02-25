import 'package:flutter_riverpod/legacy.dart';
import '../models/feed_model.dart';

final feedProvider = StateProvider<List<FeedModel>>((ref) {
  return [
    FeedModel(
      name: "Anagha Krishna",
      image: "https://picsum.photos/400",
      description:
          "Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucibus facilisis tellus.",
      time: "5 days ago",
    ),
    FeedModel(
      name: "Gokul Krishna",
      image: "https://picsum.photos/401",
      description:
          "Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucibus facilisis tellus.",
      time: "5 days ago",
    ),
  ];
});