import '../../domain/entities/feed_entity.dart';

class FeedModel extends FeedEntity {
  FeedModel({
    required super.id,
    required super.description,
    required super.image,
    required super.video,
    required super.name,
    required super.time,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: json['id'],
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      video: json['video'] ?? "",

      name: json['user'] != null ? json['user']['name'] ?? "User" : "User",

      time: _formatTime(json['created_at']),
    );
  }

  static String _formatTime(String? date) {
    if (date == null) return "";

    final DateTime parsed = DateTime.parse(date);
    final Duration diff = DateTime.now().difference(parsed);

    if (diff.inDays > 0) {
      return "${diff.inDays}d ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }
}
