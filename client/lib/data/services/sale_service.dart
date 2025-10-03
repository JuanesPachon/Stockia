import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_response.dart';
import '../models/sale/sale.dart';
import '../models/sale/create_sale_request.dart';

class SaleService {
  static final SaleService _instance = SaleService._internal();
  factory SaleService() => _instance;
  SaleService._internal();

  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Sale>> createSale(CreateSaleRequest request) async {
    try {
      final response = await _apiClient.post<Sale>(
        ApiEndpoints.sales,
        request.toJson(),
        fromJson: (json) => Sale.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al crear venta: $e');
    }
  }

  Future<ApiResponse<List<Sale>>> getSales({String order = 'desc'}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.sales}?order=$order',
      );

      if (response.success && response.data != null) {
        final data = response.data;
        if (data is List) {
          final sales = <Sale>[];
          for (var item in data) {
            try {
              if (item is Map<String, dynamic>) {
                sales.add(Sale.fromJson(item));
              }
            } catch (e) {
              continue;
            }
          }
          return ApiResponse.success(data: sales);
        }
      }

      return ApiResponse.error(response.error ?? 'Error al obtener ventas');
    } catch (e) {
      return ApiResponse.error('Error al obtener ventas: $e');
    }
  }

  Future<ApiResponse<Sale>> getSaleById(String saleId) async {
    try {
      final response = await _apiClient.get<Sale>(
        ApiEndpoints.saleById(saleId),
        fromJson: (json) => Sale.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al obtener venta: $e');
    }
  }
}