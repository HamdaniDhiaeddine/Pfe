import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../constants/constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthInterceptor(this._dio, this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for login endpoint
    if (options.path == ApiConstants.login) {
      return handler.next(options);
    }

    try {
      final token = await _storage.read(key: 'jwt_token');
      debugPrint('Token for request: $token'); // Debug log
      
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        debugPrint('Added token to request headers: ${options.headers}'); // Debug log
      } else {
        debugPrint('No token found for request to: ${options.path}'); // Debug log
      }
    } catch (e) {
      debugPrint('Error reading token: $e'); // Debug log
    }
    
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    debugPrint('Request error: ${err.response?.statusCode}'); // Debug log
    debugPrint('Request headers: ${err.requestOptions.headers}'); // Debug log
    
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      debugPrint('Authentication error. Clearing token.'); // Debug log
      await _storage.delete(key: 'jwt_token');
    }
    
    return handler.next(err);
  }
}