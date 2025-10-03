import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/api/api_response.dart';
import '../models/expense/expense.dart';
import '../models/expense/create_expense_request.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Expense>> createExpense(CreateExpenseRequest request) async {
    try {
      final response = await _apiClient.post<Expense>(
        ApiEndpoints.expenses,
        request.toJson(),
        fromJson: (json) => Expense.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al crear gasto: $e');
    }
  }

  Future<ApiResponse<List<Expense>>> getExpenses({String order = 'desc'}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.expenses}?order=$order',
      );

      if (response.success && response.data != null) {
        final data = response.data;
        if (data is List) {
          final expenses = <Expense>[];
          for (var item in data) {
            try {
              if (item is Map<String, dynamic>) {
                expenses.add(Expense.fromJson(item));
              }
            } catch (e) {
              continue;
            }
          }
          return ApiResponse.success(data: expenses);
        }
      }

      return ApiResponse.error(response.error ?? 'Error al obtener gastos');
    } catch (e) {
      return ApiResponse.error('Error al obtener gastos: $e');
    }
  }

  Future<ApiResponse<Expense>> getExpenseById(String expenseId) async {
    try {
      final response = await _apiClient.get<Expense>(
        ApiEndpoints.expenseById(expenseId),
        fromJson: (json) => Expense.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al obtener gasto: $e');
    }
  }

  Future<ApiResponse<Expense>> updateExpense(
    String expenseId,
    CreateExpenseRequest request,
  ) async {
    try {
      final response = await _apiClient.patch<Expense>(
        ApiEndpoints.expenseById(expenseId),
        request.toJson(),
        fromJson: (json) => Expense.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al actualizar gasto: $e');
    }
  }

  Future<ApiResponse<String>> deleteExpense(String expenseId) async {
    try {
      final response = await _apiClient.delete<String>(
        ApiEndpoints.expenseById(expenseId),
      );

      return response;
    } catch (e) {
      return ApiResponse.error('Error al eliminar gasto: $e');
    }
  }

}