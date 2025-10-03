import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_response.dart';
import '../models/provider/provider.dart';
import '../models/provider/create_provider_request.dart';

class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Provider>> createProvider(CreateProviderRequest request) async {
    try {
      final response = await _apiClient.post<Provider>(
        ApiEndpoints.providers,
        request.toJson(),
        fromJson: (json) => Provider.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al crear proveedor: $e');
    }
  }

  Future<ApiResponse<List<Provider>>> getProviders({String order = 'desc'}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.providers}?order=$order',
      );

      if (response.success && response.data != null) {
        final data = response.data;
        if (data is List) {
          final providers = <Provider>[];
          for (var item in data) {
            try {
              if (item is Map<String, dynamic>) {
                providers.add(Provider.fromJson(item));
              }
            } catch (e) {
              continue;
            }
          }
          return ApiResponse.success(data: providers);
        }
      }

      return ApiResponse.error(response.error ?? 'Error al obtener proveedores');
    } catch (e) {
      return ApiResponse.error('Error al obtener proveedores: $e');
    }
  }

  Future<ApiResponse<Provider>> getProviderById(String providerId) async {
    try {
      final response = await _apiClient.get<Provider>(
        ApiEndpoints.providerById(providerId),
        fromJson: (json) => Provider.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al obtener proveedor: $e');
    }
  }

  Future<ApiResponse<Provider>> updateProvider(
    String providerId,
    CreateProviderRequest request,
  ) async {
    try {
      final response = await _apiClient.patch<Provider>(
        ApiEndpoints.providerById(providerId),
        request.toJson(),
        fromJson: (json) => Provider.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al actualizar proveedor: $e');
    }
  }

  Future<ApiResponse<String>> deleteProvider(String providerId) async {
    try {
      final response = await _apiClient.delete<String>(
        ApiEndpoints.providerById(providerId),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al eliminar proveedor: $e');
    }
  }

}