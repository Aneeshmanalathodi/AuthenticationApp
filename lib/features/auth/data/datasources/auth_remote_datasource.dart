import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String phone);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> login(String phone) async {
    try {
      final response = await dio.post(
        ApiConstants.otpVerified,
        data: FormData.fromMap({"country_code": "+91", "phone": phone}),
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        if (response.data["status"] == true) {
          return AuthResponseModel.fromJson(response.data["token"]);
        } else {
          throw ServerException("Invalid login");
        }
      } else {
        throw ServerException("Login failed");
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?["message"] ?? e.message ?? "Server error",
      );
    }
  }
}
