import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/services/expense_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/expense.dart';
import '../../../../data/models/category.dart';
import 'stat_card.dart';
import 'top_list_card.dart';
import 'items_list_card.dart';
import 'detail_card.dart';

class GastosTab extends StatefulWidget {
  const GastosTab({super.key});

  @override
  State<GastosTab> createState() => _GastosTabState();
}

class _GastosTabState extends State<GastosTab> {
  final ExpenseService _expenseService = ExpenseService();
  final CategoryService _categoryService = CategoryService();
  
  List<Expense> _expenses = [];
  List<Category> _categories = [];
  bool _isLoadingExpenses = false;
  bool _isLoadingCategories = false;
  
  String _selectedTimeRange = 'Hoy';
  String? _selectedCategoryId;
  
  int _totalExpenses = 0;
  double _totalAmount = 0.0;
  List<String> _topCategories = [];
  List<Map<String, String>> _latestExpenses = [];
  int _selectedCategoryCount = 0;
  double _selectedCategoryAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadExpenses(),
      _loadCategories(),
    ]);
    _calculateStats();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoadingExpenses = true;
    });

    try {
      final response = await _expenseService.getExpenses(order: 'desc');
      if (mounted && response.success && response.data != null) {
        setState(() {
          _expenses = response.data!;
          _isLoadingExpenses = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingExpenses = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingExpenses = false;
        });
      }
    }
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

  void _calculateStats() {
    final filteredExpenses = _filterExpensesByTimeRange(_expenses, _selectedTimeRange);
    
    _totalExpenses = filteredExpenses.length;
    _totalAmount = filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    
    Map<String, double> categoryAmounts = {};
    for (var expense in filteredExpenses) {
      if (expense.categoryId != null) {
        final category = _categories.firstWhere(
          (cat) => cat.id == expense.categoryId,
          orElse: () => Category(id: '', userId: '', name: 'Sin categoría', createdAt: DateTime.now()),
        );
        categoryAmounts[category.name] = (categoryAmounts[category.name] ?? 0.0) + expense.amount;
      }
    }
    
    var sortedCategories = categoryAmounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _topCategories = sortedCategories.take(3).map((e) => e.key).toList();
    
    _latestExpenses = filteredExpenses.take(3).map((expense) => {
      'Gasto #${expense.id.substring(expense.id.length - 3)}': '\$${expense.amount.toStringAsFixed(0)}'
    }).toList();
    
    if (_selectedCategoryId != null) {
      final categoryExpenses = filteredExpenses.where((expense) => expense.categoryId == _selectedCategoryId);
      _selectedCategoryCount = categoryExpenses.length;
      _selectedCategoryAmount = categoryExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    } else {
      _selectedCategoryCount = _totalExpenses;
      _selectedCategoryAmount = _totalAmount;
    }
    
    setState(() {});
  }

  List<Expense> _filterExpensesByTimeRange(List<Expense> expenses, String timeRange) {
    final now = DateTime.now();
    DateTime startDate;
    
    switch (timeRange) {
      case 'Hoy':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Esta semana':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'Este mes':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Este año':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        return expenses;
    }
    
    return expenses.where((expense) => expense.createdAt.isAfter(startDate)).toList();
  }

  void _onTimeRangeChanged(String newValue) {
    setState(() {
      _selectedTimeRange = newValue;
    });
    _calculateStats();
  }

  void _onCategoryChanged(String? newValue) {
    setState(() {
      _selectedCategoryId = newValue;
    });
    _calculateStats();
  }

  Widget _buildDetailCard() {
    List<String> categoryItems = ['Todas'];
    categoryItems.addAll(_categories.map((category) => category.name).toList());
    
    String selectedCategoryName = 'Todas';
    if (_selectedCategoryId != null) {
      final selectedCategory = _categories.firstWhere(
        (category) => category.id == _selectedCategoryId,
        orElse: () => Category(id: '', userId: '', name: 'Todas', createdAt: DateTime.now()),
      );
      selectedCategoryName = selectedCategory.name;
    }

    return DetailCard(
      title: 'Detalle por categoría:',
      dropdowns: [
        DetailDropdown(
          label: 'Rango de tiempo:',
          value: _selectedTimeRange,
          items: ['Hoy', 'Esta semana', 'Este mes', 'Este año'],
          onChanged: _onTimeRangeChanged,
        ),
        DetailDropdown(
          label: 'Categoría:',
          value: selectedCategoryName,
          items: categoryItems,
          onChanged: (String value) {
            if (value == 'Todas') {
              _onCategoryChanged(null);
            } else {
              final category = _categories.firstWhere(
                (category) => category.name == value,
                orElse: () => Category(id: '', userId: '', name: '', createdAt: DateTime.now()),
              );
              if (category.id.isNotEmpty) {
                _onCategoryChanged(category.id);
              }
            }
          },
        ),
      ],
      stats: [
        {'Cantidad de gastos:': '$_selectedCategoryCount'},
        {'Dinero en gastos:': '\$${_selectedCategoryAmount.toStringAsFixed(0)}'},
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingExpenses || _isLoadingCategories) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.mainBlue,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatCard(
            label: 'Gastos totales:', 
            value: '$_totalExpenses', 
            isEven: true
          ),
          StatCard(
            label: 'Total dinero en gastos:', 
            value: '\$${_totalAmount.toStringAsFixed(0)}', 
            isEven: true
          ),

          const SizedBox(height: 5),

          TopListCard(
            title: 'Categorías con más gastos:',
            items: _topCategories.isEmpty ? ['Sin datos'] : _topCategories,
          ),

          ItemListCard(
            title: 'Últimos gastos:',
            items: _latestExpenses.isEmpty ? [{'Sin gastos': '\$0'}] : _latestExpenses,
          ),

          _buildDetailCard(),
        ],
      ),
    );
  }
}