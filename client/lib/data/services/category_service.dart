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

  
}