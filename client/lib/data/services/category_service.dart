import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_response.dart';
import '../models/category.dart';
import '../models/category/create_category_request.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Category>> createCategory(CreateCategoryRequest request) async {
    try {
      final response = await _apiClient.post<Category>(
        ApiEndpoints.categories,
        request.toJson(),
        fromJson: (json) => Category.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al crear categoría: $e');
    }
  }

  Future<ApiResponse<List<Category>>> getCategories({String order = 'desc'}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.categories}?order=$order',
      );

      if (response.success && response.data != null) {
        final data = response.data;
        if (data is List) {
          final categories = data.map((item) => Category.fromJson(item as Map<String, dynamic>)).toList();
          return ApiResponse.success(data: categories);
        }
      }

      return ApiResponse.error(response.error ?? 'Error al obtener categorías');
    } catch (e) {
      return ApiResponse.error('Error al obtener categorías: $e');
    }
  }

  Future<ApiResponse<Category>> getCategoryById(String categoryId) async {
    try {
      final response = await _apiClient.get<Category>(
        ApiEndpoints.categoryById(categoryId),
        fromJson: (json) => Category.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al obtener categoría: $e');
    }
  }

  Future<ApiResponse<Category>> updateCategory(
    String categoryId,
    CreateCategoryRequest request,
  ) async {
    try {
      final response = await _apiClient.patch<Category>(
        ApiEndpoints.categoryById(categoryId),
        request.toJson(),
        fromJson: (json) => Category.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al actualizar categoría: $e');
    }
  }

  Future<ApiResponse<String>> deleteCategory(String categoryId) async {
    try {
      final response = await _apiClient.delete<String>(
        ApiEndpoints.categoryById(categoryId),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al eliminar categoría: $e');
    }
  }
}