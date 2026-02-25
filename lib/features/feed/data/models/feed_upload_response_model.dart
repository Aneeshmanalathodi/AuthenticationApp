class FeedUploadResponseModel {
  final bool success;
  final String message;

  FeedUploadResponseModel({
    required this.success,
    required this.message,
  });

  factory FeedUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return FeedUploadResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}