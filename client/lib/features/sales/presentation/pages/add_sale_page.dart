import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../data/services/product_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/sale_service.dart';
import '../../../../data/models/product/product.dart';
import '../../../../data/models/category/category.dart';
import '../../../../data/models/sale/create_sale_request.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../widgets/product_sale_card.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  int _currentBottomIndex = 1;
  String _selectedOrderBy = 'desc';
  String? _selectedCategoryId;

  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final SaleService _saleService = SaleService();

  bool _isLoadingProducts = false;
  bool _isLoadingCategories = false;
  bool _isCreatingSale = false;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  final Map<String, int> _productQuantities = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      final response = await _productService.getProducts(
        order: _selectedOrderBy,
      );

      if (mounted && response.success && response.data != null) {
        setState(() {
          _allProducts = response.data!;
          _applyFilters();
          _isLoadingProducts = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProducts = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error ?? 'Error al cargar productos'),
              backgroundColor: Colors.red[800],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
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

  void _applyFilters() {
    List<Product> filtered = List.from(_allProducts);

    if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
      filtered = filtered
          .where((product) => product.categoryId == _selectedCategoryId)
          .toList();
    }

    if (_selectedOrderBy == 'desc') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  Future<void> _createSale() async {
    final selectedProducts = _productQuantities.entries
        .where((entry) => entry.value > 0)
        .toList();

    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar al menos un producto'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCreatingSale = true;
    });

    try {
      final List<CreateSaleProductRequest> saleProducts = [];
      double total = 0.0;

      for (var entry in selectedProducts) {
        final product = _allProducts.firstWhere((p) => p.id == entry.key);

        if (entry.value > product.stock) {
          if (mounted) {
            setState(() {
              _isCreatingSale = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Stock insuficiente para ${product.name}. Stock disponible: ${product.stock}',
                ),
                backgroundColor: Colors.red[800],
              ),
            );
          }
          return;
        }

        saleProducts.add(
          CreateSaleProductRequest(productId: entry.key, quantity: entry.value),
        );

        total += product.price * entry.value;
      }

      final request = CreateSaleRequest(products: saleProducts, total: total);

      final response = await _saleService.createSale(request);

      if (mounted) {
        setState(() {
          _isCreatingSale = false;
        });

        if (response.success && response.data != null) {
          final sale = response.data!;

          setState(() {
            _productQuantities.clear();
          });

          _loadProducts();

          showSuccessSnackBar(
            context,
            action: 'agregó',
            resource: 'venta',
            gender: 'la',
            resourceName: 'Total: ${CurrencyFormatter.formatCOP(sale.total)}',
          );
          Navigator.pop(context, true);
        } else {
          String errorMessage = 'Error al crear la venta, intente nuevamente.';

          final error = response.error?.toLowerCase() ?? '';

          if (error.contains('not found') || error.contains('not belong')) {
            errorMessage = 'Uno o más productos no están disponibles.';
          } else if (error.contains('insufficient_stock')) {
            errorMessage =
                'Stock insuficiente para algunos productos. Refresque la página para ver el stock actualizado.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red[800],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCreatingSale = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = 0.0;
    for (var entry in _productQuantities.entries) {
      if (entry.value > 0) {
        final product = _allProducts.firstWhere(
          (p) => p.id == entry.key,
          orElse: () => Product(
            id: '',
            userId: '',
            name: '',
            stock: 0,
            price: 0.0,
            createdAt: DateTime.now(),
          ),
        );
        total += product.price * entry.value;
      }
    }

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
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Ventas > Agregar',
            style: const TextStyle(
              color: AppColors.mainBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.mainWhite,
              border: Border(
                bottom: BorderSide(color: AppColors.mainBlue, width: 2),
              ),
            ),
            child: const Text(
              'Productos:',
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
                        value: _selectedOrderBy == 'desc'
                            ? 'Mas recientes'
                            : 'Mas antiguos',
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
                              _selectedOrderBy = newValue == 'Mas recientes'
                                  ? 'desc'
                                  : 'asc';
                            });
                            _loadProducts();
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
                          : DropdownButton<String?>(
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
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text(
                                    'Todas las categorías',
                                    style: TextStyle(),
                                  ),
                                ),
                                ..._categories.map<DropdownMenuItem<String?>>((
                                  Category category,
                                ) {
                                  return DropdownMenuItem<String?>(
                                    value: category.id,
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(),
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategoryId = newValue;
                                });
                                _applyFilters();
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
          Expanded(
            child: _isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay productos disponibles',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final currentQuantity =
                          _productQuantities[product.id] ?? 0;

                      return ProductSaleCard(
                        name: product.name,
                        stock: product.stock,
                        price: product.price,
                        quantity: currentQuantity,
                        imageUrl: product.imageUrl,
                        isEven: index % 2 == 0,
                        onIncrease: () {
                          setState(() {
                            if (currentQuantity < product.stock) {
                              _productQuantities[product.id] =
                                  currentQuantity + 1;
                            }
                          });
                        },
                        onDecrease: () {
                          setState(() {
                            if (currentQuantity > 0) {
                              _productQuantities[product.id] =
                                  currentQuantity - 1;
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.mainBlue, width: 2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        color: AppColors.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatCOP(total),
                      style: const TextStyle(
                        color: AppColors.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DefaultButton(
                  text: _isCreatingSale ? 'Creando venta...' : 'Agregar venta',
                  onPressed: _isCreatingSale ? null : _createSale,
                ),
              ],
            ),
          ),
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
