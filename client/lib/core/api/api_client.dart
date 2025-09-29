import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'api_response.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _dio = Dio();
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));
    
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  late final Dio _dio;
  late final CookieJar _cookieJar;

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final options = Options();
      if (additionalHeaders != null) {
        options.headers = additionalHeaders;
      }

      final response = await _dio.get(endpoint, options: options);

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    Map<String, dynamic> body, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final options = Options();
      if (additionalHeaders != null) {
        options.headers = additionalHeaders;
      }

      final response = await _dio.post(
        endpoint,
        data: body,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
      
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint,
    Map<String, dynamic> body, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final options = Options();
      if (additionalHeaders != null) {
        options.headers = additionalHeaders;
      }

      final response = await _dio.put(
        endpoint,
        data: body,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    Map<String, dynamic> body, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final options = Options();
      if (additionalHeaders != null) {
        options.headers = additionalHeaders;
      }

      final response = await _dio.patch(
        endpoint,
        data: body,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final options = Options();
      if (additionalHeaders != null) {
        options.headers = additionalHeaders;
      }

      final response = await _dio.delete(endpoint, options: options);
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T? Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          return ApiResponse.fromJson(response.data, fromJson);
        } else {
          return ApiResponse.success();
        }
      }

      final errorMessage = response.data is Map<String, dynamic>
          ? response.data['message'] ?? 'Error del servidor (${response.statusCode})'
          : 'Error del servidor (${response.statusCode})';
      
      return ApiResponse.error(errorMessage);
    } catch (e) {
      return ApiResponse.error(
        'Error del servidor (${response.statusCode}): ${response.data}',
      );
    }
  }

  ApiResponse<T> _handleDioError<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse.error('Tiempo de conexión agotado');
      case DioExceptionType.sendTimeout:
        return ApiResponse.error('Tiempo de envío agotado');
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error('Tiempo de respuesta agotado');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return ApiResponse.error(data['message']);
        }
        
        return ApiResponse.error('Error del servidor ($statusCode)');
      case DioExceptionType.cancel:
        return ApiResponse.error('Petición cancelada');
      case DioExceptionType.connectionError:
        return ApiResponse.error('Sin conexión a internet');
      default:
        return ApiResponse.error('Error inesperado: ${e.message}');
    }
  }

  void dispose() {
    _dio.close();
  }
}