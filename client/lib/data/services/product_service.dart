import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_response.dart';
import '../models/product.dart';
import '../models/product/create_product_request.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Product>> createProduct(CreateProductRequest request) async {
    try {
      final response = await _apiClient.post<Product>(
        ApiEndpoints.products,
        request.toJson(),
        fromJson: (json) => Product.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al crear producto: $e');
    }
  }

  Future<ApiResponse<List<Product>>> getProducts({String order = 'desc'}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.products}?order=$order',
      );

      if (response.success && response.data != null) {
        final data = response.data;
        if (data is List) {
          final products = <Product>[];
          for (var item in data) {
            try {
              if (item is Map<String, dynamic>) {
                products.add(Product.fromJson(item));
              }
            } catch (e) {
              continue;
            }
          }
          return ApiResponse.success(data: products);
        }
      }

      return ApiResponse.error(response.error ?? 'Error al obtener productos');
    } catch (e) {
      return ApiResponse.error('Error al obtener productos: $e');
    }
  }

  Future<ApiResponse<Product>> getProductById(String productId) async {
    try {
      final response = await _apiClient.get<Product>(
        ApiEndpoints.productById(productId),
        fromJson: (json) => Product.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al obtener producto: $e');
    }
  }

  Future<ApiResponse<Product>> updateProduct(
    String productId,
    CreateProductRequest request,
  ) async {
    try {
      final response = await _apiClient.patch<Product>(
        ApiEndpoints.productById(productId),
        request.toJson(),
        fromJson: (json) => Product.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al actualizar producto: $e');
    }
  }

  Future<ApiResponse<String>> deleteProduct(String productId) async {
    try {
      final response = await _apiClient.delete<String>(
        ApiEndpoints.productById(productId),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al eliminar producto: $e');
    }
  }

}