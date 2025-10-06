import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_response.dart';
import '../models/auth/login_request.dart';
import '../models/auth/register_request.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<User>> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post<User>(
        ApiEndpoints.register,
        request.toJson(),
        fromJson: (json) => User.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al registrar usuario: $e');
    }
  }

  Future<ApiResponse<String>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post<String>(
        ApiEndpoints.login,
        request.toJson(),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al iniciar sesión: $e');
    }
  }

  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final response = await _apiClient.get<User>(
        ApiEndpoints.user,
        fromJson: (json) => User.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al obtener usuario: $e');
    }
  }

  Future<bool> hasActiveSession() async {
    return await _apiClient.hasActiveSession();
  }

  Future<ApiResponse<String>> logout() async {
    try {
      await _apiClient.clearSession();
      return ApiResponse.success(message: 'Sesión cerrada exitosamente');
    } catch (e) {
      return ApiResponse.error('Error al cerrar sesión: $e');
    }
  }

  Future<ApiResponse<User>> updateUser({
    String? email,
    String? name,
    String? businessName,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};
      
      if (email != null) updateData['email'] = email;
      if (name != null) updateData['name'] = name;
      if (businessName != null) updateData['businessName'] = businessName;

      final response = await _apiClient.patch<User>(
        ApiEndpoints.user,
        updateData,
        fromJson: (json) => User.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al actualizar usuario: $e');
    }
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~_\-\.\,\;\:\?\^]).{8,}$');
    return regex.hasMatch(password);
  }

  static Map<String, String?> validateRegisterData({
    required String email,
    required String password,
    required String name,
  }) {
    Map<String, String?> errors = {};

    if (email.isEmpty) {
      errors['email'] = 'El email es requerido';
    } else if (!isValidEmail(email)) {
      errors['email'] = 'Email inválido';
    }

    if (password.isEmpty) {
      errors['password'] = 'La contraseña es requerida';
    } else if (!isValidPassword(password)) {
      errors['password'] = 'La contraseña debe tener al menos 6 caracteres';
    }

    if (name.isEmpty) {
      errors['name'] = 'El nombre es requerido';
    }

    return errors;
  }
}