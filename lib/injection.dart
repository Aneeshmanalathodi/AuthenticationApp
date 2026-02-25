import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/api_constants.dart';
import 'core/constants/app_constants.dart';

late SharedPreferences sharedPrefs;

Future<void> initDependencies() async {
  sharedPrefs = await SharedPreferences.getInstance();
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  return sharedPrefs;
});

final dioProvider = Provider<Dio>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {"Accept": "application/json"},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = prefs.getString(AppConstants.tokenKey);

        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }

        print("========== API REQUEST ==========");
        print("URL: ${options.baseUrl}${options.path}");
        print("METHOD: ${options.method}");
        print("HEADERS: ${options.headers}");
        print("BODY: ${options.data}");
        print("=================================");

        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("========== API RESPONSE ==========");
        print("URL: ${response.requestOptions.uri}");
        print("STATUS: ${response.statusCode}");
        print("DATA: ${response.data}");
        print("==================================");

        return handler.next(response);
      },
      onError: (e, handler) {
        print("========== API ERROR ==========");
        print("URL: ${e.requestOptions.uri}");
        print("STATUS: ${e.response?.statusCode}");
        print("MESSAGE: ${e.message}");
        print("DATA: ${e.response?.data}");
        print("================================");

        return handler.next(e);
      },
    ),
  );

  return dio;
});
