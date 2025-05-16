

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/constants.dart';
import 'auth_interceptor.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    // auth interceptor 
    _dio.interceptors.add(AuthInterceptor(_dio, _storage));

    // logging interceptor
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true, 
      logPrint: (obj) {
        debugPrint('DIO LOG: ${obj.toString()}');
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      debugPrint('Making GET request to: $path'); 
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      
      debugPrint('Response status: ${response.statusCode}'); 
      
      if (response.statusCode == 403) {
        throw 'Authentication required. Please login again.';
      }

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      return response;
    } on DioException catch (e) {
      debugPrint('DIO Error: ${e.message}'); 
      debugPrint('DIO Error Response: ${e.response?.data}'); 
      
      if (e.response?.statusCode == 403) {
        throw 'Authentication required. Please login again.';
      }
      
      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response?.data as Map<String, dynamic>;
        throw errorData['message'] ?? 'An error occurred';
      }
      throw 'Network error occurred';
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      debugPrint('Making POST request to $path with data: $data'); 
      
      final response = await _dio.post(path, data: data);
      
      debugPrint('Response status: ${response.statusCode}'); 
      debugPrint('Response data: ${response.data}'); 
      
      if (response.statusCode == 403) {
        throw 'Authentication required. Please login again.';
      }

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      
      return response;
    } on DioException catch (e) {
      debugPrint('DioException: ${e.toString()}'); 
      debugPrint('Response data: ${e.response?.data}'); 
      
      if (e.response?.statusCode == 403) {
        throw 'Authentication required. Please login again.';
      }
      
      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response?.data as Map<String, dynamic>;
        throw errorData['message'] ?? 'An error occurred';
      }
      
      throw 'Network error occurred';
    }
  }

  

  

  Future<Response> put(String path, dynamic data) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (e.response == null) {
      return 'Network error. Please check your internet connection.';
    }

    switch (e.response?.statusCode) {
      case 400:
        return e.response?.data['message'] ?? 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}