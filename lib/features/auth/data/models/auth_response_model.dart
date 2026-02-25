class AuthResponseModel {
  final String accessToken;
  final String refresh;

  AuthResponseModel({required this.accessToken, required this.refresh});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }
}
