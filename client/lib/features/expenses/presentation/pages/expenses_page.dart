import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/expense_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/provider_service.dart';
import '../../../../data/models/expense/expense.dart';
import '../../../../data/models/category/category.dart';
import '../../../../data/models/provider/provider.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../widgets/expense_card.dart';
import 'expense_detail_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  int _currentBottomIndex = 1;
  String _selectedFilter = 'Mas recientes';
  String? _selectedCategoryId;
  final ExpenseService _expenseService = ExpenseService();
  final CategoryService _categoryService = CategoryService();
  final ProviderService _providerService = ProviderService();

  List<Expense> _expenses = [];
  List<Category> _categories = [];
  List<Provider> _providers = [];
  bool _isLoading = true;
  bool _isLoadingCategories = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProviders();
    _loadExpenses();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final response = await _categoryService.getCategories();

      if (mounted && response.success && response.data != null) {
        setState(() {
          _categories = response.data!;
          _isLoadingCategories = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingCategories = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadProviders() async {
    try {
      final response = await _providerService.getProviders();

      if (mounted && response.success && response.data != null) {
        setState(() {
          _providers = response.data!;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _providers = [];
        });
      }
    }
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final order = _selectedFilter == 'Mas recientes' ? 'desc' : 'asc';

      final response = await _expenseService.getExpenses(order: order);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.data != null) {
            List<Expense> allExpenses = response.data!;

            if (_selectedCategoryId != null &&
                _selectedCategoryId!.isNotEmpty) {
              _expenses = allExpenses
                  .where((expense) => expense.categoryId == _selectedCategoryId)
                  .toList();
            } else {
              _expenses = allExpenses;
            }
          } else {
            _errorMessage = response.error ?? 'Error al cargar gastos';
            _expenses = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error inesperado: $e';
          _expenses = [];
        });
      }
    }
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return 'Sin categoría';

    final category = _categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(
        id: '',
        userId: '',
        name: 'Categoría desconocida',
        createdAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  String _getProviderName(String? providerId) {
    if (providerId == null || providerId.isEmpty) return 'Sin proveedor';

    final provider = _providers.firstWhere(
      (prov) => prov.id == providerId,
      orElse: () => Provider(
        id: '',
        userId: '',
        name: 'Proveedor desconocido',
        categoryId: null,
        contact: '',
        description: '',
        status: true,
        createdAt: DateTime.now(),
      ),
    );
    return provider.name;
  }

  Widget _buildExpensesList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainBlue),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[800], fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExpenses,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainBlue,
                foregroundColor: AppColors.mainWhite,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_expenses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_outlined, size: 64, color: AppColors.mainBlue),
            SizedBox(height: 16),
            Text(
              'No hay gastos disponibles',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Agrega un gasto o cambia el filtro',
              style: TextStyle(color: AppColors.mainBlue, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return ExpenseCard(
          id: expense.id,
          title: expense.title,
          category: _getCategoryName(expense.categoryId),
          description: expense.description.length > 50
              ? '${expense.description.substring(0, 50)}...'
              : expense.description,
          amount: CurrencyFormatter.formatCOP(expense.amount),
          date: '${expense.createdAt.day.toString().padLeft(2, '0')}-${expense.createdAt.month.toString().padLeft(2, '0')}-${expense.createdAt.year}',
          onDetailsPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseDetailPage(
                  id: expense.id,
                  title: expense.title,
                  category: _getCategoryName(expense.categoryId),
                  categoryId: expense.categoryId,
                  amount: CurrencyFormatter.formatCOP(expense.amount),
                  providerId: expense.providerId,
                  provider: _getProviderName(expense.providerId),
                  description: expense.description,
                ),
              ),
            );
            if (result == true) {
              _loadExpenses();
            }
          },
          isEven: index % 2 == 0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.mainBlue, width: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mainBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Gastos',
          style: TextStyle(
            color: AppColors.mainBlue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: DefaultButton(
              text: 'Agregar gastos', 
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.addExpense);
                if (result == true) {
                  _loadExpenses();
                }
              }
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Container(
            decoration: const BoxDecoration(color: AppColors.mainBlue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Ordenar por :',
                        style: TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      DropdownButton<String>(
                        value: _selectedFilter,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.mainWhite,
                        ),
                        style: const TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Mas recientes',
                            child: Text('Mas recientes', style: TextStyle()),
                          ),
                          DropdownMenuItem(
                            value: 'Mas antiguos',
                            child: Text('Mas antiguos', style: TextStyle()),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedFilter = newValue;
                            });
                            _loadExpenses();
                          }
                        },
                        dropdownColor: AppColors.mainBlue,
                      ),
                    ],
                  ),

                  const Divider(
                    color: AppColors.mainWhite,
                    thickness: 2,
                    height: 0,
                  ),

                  Row(
                    children: [
                      const Text(
                        'Filtrar categoría:',
                        style: TextStyle(
                          color: AppColors.mainWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      _isLoadingCategories
                          ? Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                top: 14,
                                bottom: 14,
                              ),
                              child: Text(
                                'Cargando...',
                                style: TextStyle(color: AppColors.mainWhite),
                              ),
                            )
                          : DropdownButton<String>(
                              value: _selectedCategoryId,
                              underline: const SizedBox(),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.mainWhite,
                              ),
                              style: const TextStyle(
                                color: AppColors.mainWhite,
                                fontSize: 14,
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Todas las categorías', style: TextStyle(color: AppColors.mainWhite)),
                                ),
                                ..._categories.map((category) => DropdownMenuItem<String>(
                                  value: category.id,
                                  child: Text(
                                    category.name,
                                    style: const TextStyle(color: AppColors.mainWhite),
                                  ),
                                )),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategoryId = newValue;
                                });
                                _loadExpenses();
                              },
                              dropdownColor: AppColors.mainBlue,
                            ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.mainBlue, thickness: 2, height: 0),

          Expanded(child: _buildExpensesList()),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.management);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.settings);
              break;
          }
        },
      ),
    );
  }
}