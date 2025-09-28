import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_response.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();

  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    T? Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final headers = {..._defaultHeaders};
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final response = await _client.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('Sin conexión a internet');
    } on HttpException {
      return ApiResponse.error('Error de conexión');
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
      final headers = {..._defaultHeaders};
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final response = await _client.post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('Sin conexión a internet');
    } on HttpException {
      return ApiResponse.error('Error de conexión');
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
      final headers = {..._defaultHeaders};
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final response = await _client.put(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('Sin conexión a internet');
    } on HttpException {
      return ApiResponse.error('Error de conexión');
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
      final headers = {..._defaultHeaders};
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      final response = await _client.delete(
        Uri.parse(endpoint),
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('Sin conexión a internet');
    } on HttpException {
      return ApiResponse.error('Error de conexión');
    } catch (e) {
      return ApiResponse.error('Error inesperado: $e');
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T? Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.fromJson(jsonData, fromJson);
      }

      return ApiResponse.error(
        jsonData['message'] ?? 'Error del servidor (${response.statusCode})',
      );
    } catch (e) {
      return ApiResponse.error(
        'Error del servidor (${response.statusCode})',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}