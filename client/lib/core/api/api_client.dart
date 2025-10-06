import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_response.dart';
import 'dart:convert';

class SharedPreferencesCookieJar implements CookieJar {
  static const String _cookieKey = 'dio_cookies';

  @override
  bool ignoreExpires = false;

  @override
  Future<List<Cookie>> loadForRequest(Uri uri) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookiesJson = prefs.getString(_cookieKey);

      if (cookiesJson == null || cookiesJson.isEmpty) {
        return [];
      }

      final cookiesData = jsonDecode(cookiesJson) as Map<String, dynamic>;
      final List<Cookie> cookies = [];

      cookiesData.forEach((domain, domainCookies) {
        if (domainCookies is Map<String, dynamic>) {
          domainCookies.forEach((path, pathCookies) {
            if (pathCookies is List) {
              for (var cookieData in pathCookies) {
                try {
                  final cookie = Cookie.fromSetCookieValue(
                    cookieData.toString(),
                  );
                  // Verificar si la cookie es válida para este URI
                  if (_isValidForUri(cookie, uri)) {
                    cookies.add(cookie);
                  }
                } catch (e) {
                  continue;
                }
              }
            }
          });
        }
      });

      return cookies;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveFromResponse(Uri uri, List<Cookie> cookies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCookiesJson = prefs.getString(_cookieKey) ?? '{}';
      final Map<String, dynamic> allCookies = jsonDecode(currentCookiesJson);

      final domain = uri.host;
      final path = uri.path.isEmpty ? '/' : uri.path;

      if (!allCookies.containsKey(domain)) {
        allCookies[domain] = <String, dynamic>{};
      }

      if (!allCookies[domain].containsKey(path)) {
        allCookies[domain][path] = <String>[];
      }

      for (var cookie in cookies) {
        // Convertir cookie a string para almacenamiento
        final cookieString =
            '${cookie.name}=${cookie.value}; Path=${cookie.path ?? '/'}; Domain=${cookie.domain ?? domain}';

        // Remover cookie existente con el mismo nombre
        (allCookies[domain][path] as List).removeWhere(
          (item) => item.toString().startsWith('${cookie.name}='),
        );

        // Agregar nueva cookie
        (allCookies[domain][path] as List).add(cookieString);
      }

      await prefs.setString(_cookieKey, jsonEncode(allCookies));
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> delete(Uri uri, [bool withDomainSharedCookie = false]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCookiesJson = prefs.getString(_cookieKey) ?? '{}';
      final Map<String, dynamic> allCookies = jsonDecode(currentCookiesJson);

      if (withDomainSharedCookie) {
        allCookies.remove(uri.host);
      } else {
        final domain = uri.host;
        final path = uri.path.isEmpty ? '/' : uri.path;

        if (allCookies.containsKey(domain)) {
          allCookies[domain].remove(path);
          if ((allCookies[domain] as Map).isEmpty) {
            allCookies.remove(domain);
          }
        }
      }

      await prefs.setString(_cookieKey, jsonEncode(allCookies));
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cookieKey);
    } catch (e) {
      return;
    }
  }

  bool _isValidForUri(Cookie cookie, Uri uri) {
    final cookieDomain = cookie.domain ?? '';
    if (cookieDomain.isNotEmpty && !uri.host.endsWith(cookieDomain)) {
      return false;
    }

    final cookiePath = cookie.path ?? '/';
    if (!uri.path.startsWith(cookiePath)) {
      return false;
    }

    if (cookie.expires != null && cookie.expires!.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _dio = Dio();
    _initializeCookieJar();

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
  late CookieJar _cookieJar;

  void _initializeCookieJar() async {
    try {
      _cookieJar = SharedPreferencesCookieJar();
      _dio.interceptors.add(CookieManager(_cookieJar));
    } catch (e) {
      _cookieJar = CookieJar();
      _dio.interceptors.add(CookieManager(_cookieJar));
    }
  }

  Future<bool> hasActiveSession() async {
    try {
      final cookies = await _cookieJar.loadForRequest(
        Uri.parse('https://stockia.onrender.com/api/v1'),
      );
      return cookies.any(
        (cookie) =>
            cookie.name == 'access_token' &&
            (cookie.expires == null || cookie.expires!.isAfter(DateTime.now())),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> clearSession() async {
    try {
      await _cookieJar.deleteAll();
    } catch (e) {
      rethrow;
    }
  }

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

      final response = await _dio.post(endpoint, data: body, options: options);

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

      final response = await _dio.put(endpoint, data: body, options: options);

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  Future<ApiResponse<T>> postFormData<T>(
    String endpoint,
    FormData formData, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final options = Options();
      if (additionalHeaders != null) {
        options.headers = {...options.headers ?? {}, ...additionalHeaders};
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  Future<ApiResponse<T>> patchFormData<T>(
    String endpoint,
    FormData formData, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final options = Options();
      if (additionalHeaders != null) {
        options.headers = {...options.headers ?? {}, ...additionalHeaders};
      }

      final response = await _dio.patch(
        endpoint,
        data: formData,
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

      final response = await _dio.patch(endpoint, data: body, options: options);

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
          final responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('success')) {
            return ApiResponse.fromJson(responseData, fromJson);
          } else {
            return ApiResponse.success();
          }
        } else {
          return ApiResponse.success();
        }
      }

      if (response.data is Map<String, dynamic>) {
        return ApiResponse.fromJson(response.data, fromJson);
      }

      return ApiResponse.error('Error del servidor (${response.statusCode})');
    } catch (e) {
      // Si hay excepción pero el status es 2xx, probablemente es problema de parsing
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Es un éxito pero hubo problema parseando, devolver éxito genérico
        return ApiResponse.success();
      }
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

        if (data is Map<String, dynamic>) {
          // Crear ApiResponse usando fromJson para capturar todos los campos
          return ApiResponse.fromJson(data, null);
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
