import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082/api'));
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioError e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle unauthorized error (e.g., token expired)
          print('Unauthorized request: ${e.response?.statusMessage}');
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response> post(String endpoint, dynamic data) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }
}