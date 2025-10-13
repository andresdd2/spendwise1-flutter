import 'package:dio/dio.dart';
import 'package:spendwise_1/infrastructure/services/token_storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorageService.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('Error: ${err.response?.statusCode}');
    print('Response: ${err.response?.data}');
    return handler.next(err);
  }
}