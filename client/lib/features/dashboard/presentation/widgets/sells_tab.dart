import 'package:client/features/dashboard/presentation/widgets/top_list_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/services/sale_service.dart';
import '../../../../data/services/product_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/sale/sale.dart';
import '../../../../data/models/product/product.dart';
import '../../../../data/models/category/category.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'stat_card.dart';
import 'items_list_card.dart';
import 'detail_card.dart';

class VentasTab extends StatefulWidget {
  const VentasTab({super.key});

  @override
  State<VentasTab> createState() => _VentasTabState();
}

class _VentasTabState extends State<VentasTab> {
  final SaleService _saleService = SaleService();
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  
  List<Sale> _sales = [];
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoadingSales = false;
  bool _isLoadingProducts = false;
  bool _isLoadingCategories = false;
  
  String _selectedTimeRange = 'Hoy';
  String? _selectedProductId;
  
  String _selectedTimeRangeCategory = 'Hoy';
  String? _selectedCategoryId;
  
  int _totalSales = 0;
  double _totalRevenue = 0.0;
  List<String> _topProducts = [];
  List<Map<String, String>> _latestSales = [];
  int _selectedProductUnits = 0;
  double _selectedProductRevenue = 0.0;
  int _selectedCategoryUnits = 0;
  double _selectedCategoryRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadSales(),
      _loadProducts(),
      _loadCategories(),
    ]);
    _calculateStats();
  }

  Future<void> _loadSales() async {
    setState(() {
      _isLoadingSales = true;
    });

    try {
      final response = await _saleService.getSales(order: 'desc');
      if (mounted && response.success && response.data != null) {
        setState(() {
          _sales = response.data!;
          _isLoadingSales = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingSales = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSales = false;
        });
      }
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      final response = await _productService.getProducts();
      if (mounted && response.success && response.data != null) {
        setState(() {
          _products = response.data!;
          _isLoadingProducts = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProducts = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
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
    final filteredSales = _filterSalesByTimeRange(_sales, _selectedTimeRange);
    
    _totalSales = filteredSales.length;
    _totalRevenue = filteredSales.fold(0.0, (sum, sale) => sum + sale.total);
    
    Map<String, int> productSales = {};
    for (var sale in filteredSales) {
      for (var saleProduct in sale.products) {
        final productName = saleProduct.product.name;
        productSales[productName] = (productSales[productName] ?? 0) + saleProduct.quantity;
      }
    }
    
    var sortedProducts = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _topProducts = sortedProducts.take(3).map((e) => e.key).toList();
    
    _latestSales = filteredSales.take(3).map((sale) => {
      'Venta #${sale.id.substring(sale.id.length - 6)}': CurrencyFormatter.formatCOP(sale.total)
    }).toList();
    
    if (_selectedProductId != null) {
      _selectedProductUnits = 0;
      _selectedProductRevenue = 0.0;
      
      for (var sale in filteredSales) {
        for (var saleProduct in sale.products) {
          if (saleProduct.product.id == _selectedProductId) {
            _selectedProductUnits += saleProduct.quantity;
            _selectedProductRevenue += saleProduct.product.price * saleProduct.quantity;
          }
        }
      }
    } else {
      _selectedProductUnits = filteredSales.fold(0, (sum, sale) => 
          sum + sale.products.fold(0, (productSum, saleProduct) => productSum + saleProduct.quantity));
      _selectedProductRevenue = _totalRevenue;
    }
    
    final filteredSalesCategory = _filterSalesByTimeRange(_sales, _selectedTimeRangeCategory);
    
    if (_selectedCategoryId != null) {
      _selectedCategoryUnits = 0;
      _selectedCategoryRevenue = 0.0;
      
      for (var sale in filteredSalesCategory) {
        for (var saleProduct in sale.products) {
          final category = _categories.firstWhere(
            (cat) => cat.id == saleProduct.product.categoryId,
            orElse: () => Category(id: '', userId: '', name: '', createdAt: DateTime.now()),
          );
          
          if (category.id == _selectedCategoryId) {
            _selectedCategoryUnits += saleProduct.quantity;
            _selectedCategoryRevenue += saleProduct.product.price * saleProduct.quantity;
          }
        }
      }
    } else {
      _selectedCategoryUnits = filteredSalesCategory.fold(0, (sum, sale) => 
          sum + sale.products.fold(0, (productSum, saleProduct) => productSum + saleProduct.quantity));
      _selectedCategoryRevenue = filteredSalesCategory.fold(0.0, (sum, sale) => sum + sale.total);
    }
    
    setState(() {});
  }

  List<Sale> _filterSalesByTimeRange(List<Sale> sales, String timeRange) {
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
        return sales;
    }
    
    return sales.where((sale) => sale.createdAt.isAfter(startDate)).toList();
  }

  void _onTimeRangeChanged(String newValue) {
    setState(() {
      _selectedTimeRange = newValue;
    });
    _calculateStats();
  }

  void _onProductChanged(String? newValue) {
    setState(() {
      _selectedProductId = newValue;
    });
    _calculateStats();
  }

  void _onTimeRangeCategoryChanged(String newValue) {
    setState(() {
      _selectedTimeRangeCategory = newValue;
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
    List<String> productItems = ['Todos'];
    productItems.addAll(_products.map((product) => product.name).toList());
    
    String selectedProductName = 'Todos';
    if (_selectedProductId != null) {
      final selectedProduct = _products.firstWhere(
        (product) => product.id == _selectedProductId,
        orElse: () => Product(id: '', userId: '', name: 'Todos', stock: 0, price: 0.0, createdAt: DateTime.now()),
      );
      selectedProductName = selectedProduct.name;
    }

    return DetailCard(
      title: 'Detalle por producto(s):',
      dropdowns: [
        DetailDropdown(
          label: 'Rango de tiempo:',
          value: _selectedTimeRange,
          items: ['Hoy', 'Esta semana', 'Este mes', 'Este año'],
          onChanged: _onTimeRangeChanged,
        ),
        DetailDropdown(
          label: 'Producto:',
          value: selectedProductName,
          items: productItems,
          onChanged: (String value) {
            if (value == 'Todos') {
              _onProductChanged(null);
            } else {
              final product = _products.firstWhere(
                (product) => product.name == value,
                orElse: () => Product(id: '', userId: '', name: '', stock: 0, price: 0.0, createdAt: DateTime.now()),
              );
              if (product.id.isNotEmpty) {
                _onProductChanged(product.id);
              }
            }
          },
        ),
      ],
      stats: [
        {'Unidades vendidas:': '$_selectedProductUnits'},
        {'Total dinero en ventas:': CurrencyFormatter.formatCOP(_selectedProductRevenue)},
      ],
    );
  }

  Widget _buildCategoryDetailCard() {
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
          value: _selectedTimeRangeCategory,
          items: ['Hoy', 'Esta semana', 'Este mes', 'Este año'],
          onChanged: _onTimeRangeCategoryChanged,
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
        {'Unidades vendidas:': '$_selectedCategoryUnits'},
        {'Dinero en ventas:': CurrencyFormatter.formatCOP(_selectedCategoryRevenue)},
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingSales || _isLoadingProducts || _isLoadingCategories) {
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
            label: 'Ventas totales:', 
            value: '$_totalSales', 
            isEven: true
          ),
          StatCard(
            label: 'Total dinero en ventas:', 
            value: CurrencyFormatter.formatCOP(_totalRevenue), 
            isEven: true
          ),

          const SizedBox(height: 5),

          TopListCard(
            title: 'Productos mas vendidos:',
            items: _topProducts.isEmpty ? ['Sin datos'] : _topProducts,
          ),

          ItemListCard(
            title: 'Últimas ventas:',
            items: _latestSales.isEmpty ? [{'Sin ventas': CurrencyFormatter.formatCOPFromInt(0)}] : _latestSales,
          ),

          _buildDetailCard(),

          _buildCategoryDetailCard(),
        ],
      ),
    );
  }
}
