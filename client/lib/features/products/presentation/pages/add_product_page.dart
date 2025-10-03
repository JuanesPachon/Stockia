import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/product_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/provider_service.dart';
import '../../../../data/models/product/create_product_request.dart';
import '../../../../data/models/category/category.dart';
import '../../../../data/models/provider/provider.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_dropdown.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  int _currentBottomIndex = 1;
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final ProviderService _providerService = ProviderService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingCategories = false;
  bool _isLoadingProviders = false;
  List<Category> _categories = [];
  List<Provider> _providers = [];
  String? _selectedCategoryId;
  String? _selectedProviderId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProviders();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
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
    setState(() {
      _isLoadingProviders = true;
    });

    try {
      final response = await _providerService.getProviders();

      if (mounted && response.success && response.data != null) {
        setState(() {
          _providers = response.data!;
          _isLoadingProviders = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProviders = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProviders = false;
        });
      }
    }
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateProductRequest(
        name: _nameController.text.trim(),
        categoryId: _selectedCategoryId,
        providerId: _selectedProviderId,
        stock: int.parse(_stockController.text.trim()),
        price: double.parse(_priceController.text.trim()),
      );
      final response = await _productService.createProduct(request);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success && response.data != null) {
          final product = response.data!;
          showCustomDialog(
            context,
            title: 'Se ha agregado el producto:',
            message: product.name,
            showSecondaryButton: false,
            primaryButtonText: "Aceptar",
            onPrimaryPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
          );
        } else {
          String errorMessage =
              'Error al crear el producto, intente nuevamente.';

          final error = response.error?.toLowerCase() ?? '';

          if (error.contains('duplicate')) {
            errorMessage = 'Ya existe un producto con ese nombre.';
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
          _isLoading = false;
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

  List<String> _getCategoryItems() {
    List<String> items = ['Sin categoría'];
    items.addAll(_categories.map((category) => category.name).toList());
    return items;
  }

  String _getSelectedCategoryName() {
    if (_selectedCategoryId == null) return 'Sin categoría';
    final category = _categories.firstWhere(
      (cat) => cat.id == _selectedCategoryId,
      orElse: () => Category(
        id: '',
        userId: '',
        name: 'Sin categoría',
        createdAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  void _onCategoryChanged(String? value) {
    setState(() {
      if (value == 'Sin categoría') {
        _selectedCategoryId = null;
      } else {
        final category = _categories.firstWhere(
          (cat) => cat.name == value,
          orElse: () =>
              Category(id: '', userId: '', name: '', createdAt: DateTime.now()),
        );
        _selectedCategoryId = category.id.isNotEmpty ? category.id : null;
      }
    });
  }

  List<String> _getProviderItems() {
    List<String> items = ['Sin proveedor'];
    items.addAll(_providers.map((provider) => provider.name).toList());
    return items;
  }

  String _getSelectedProviderName() {
    if (_selectedProviderId == null) return 'Sin proveedor';
    final provider = _providers.firstWhere(
      (prov) => prov.id == _selectedProviderId,
      orElse: () => Provider(
        id: '',
        userId: '',
        name: 'Sin proveedor',
        status: true,
        createdAt: DateTime.now(),
      ),
    );
    return provider.name;
  }

  void _onProviderChanged(String? value) {
    setState(() {
      if (value == 'Sin proveedor') {
        _selectedProviderId = null;
      } else {
        final provider = _providers.firstWhere(
          (prov) => prov.name == value,
          orElse: () => Provider(
            id: '',
            userId: '',
            name: '',
            status: true,
            createdAt: DateTime.now(),
          ),
        );
        _selectedProviderId = provider.id.isNotEmpty ? provider.id : null;
      }
    });
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
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Productos > Agregar',
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.mainBlue,
                      border: Border(
                        bottom: BorderSide(color: AppColors.mainBlue, width: 2),
                      ),
                    ),
                    child: const Text(
                      'Agregar nuevo producto:',
                      style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DefaultTextField(
                            label: 'Nombre del producto:',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es requerido';
                              }
                              if (value.trim().length < 2) {
                                return 'El nombre debe tener al menos 2 caracteres';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _isLoadingCategories
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Categoría:',
                                      style: TextStyle(
                                        color: AppColors.mainBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          205,
                                          187,
                                          152,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: AppColors.mainBlue,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Text(
                                          'Cargando...',
                                          style: TextStyle(
                                            color: AppColors.mainBlue,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : DefaultDropdown(
                                  label: 'Categoría:',
                                  value: _getSelectedCategoryName(),
                                  items: _getCategoryItems(),
                                  onChanged: _onCategoryChanged,
                                  hintText: 'Seleccione una categoría',
                                ),

                          const SizedBox(height: 20),

                          _isLoadingProviders
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Proveedor:',
                                      style: TextStyle(
                                        color: AppColors.mainBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          205,
                                          187,
                                          152,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: AppColors.mainBlue,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Text(
                                          'Cargando...',
                                          style: TextStyle(
                                            color: AppColors.mainBlue,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : DefaultDropdown(
                                  label: 'Proveedor:',
                                  value: _getSelectedProviderName(),
                                  items: _getProviderItems(),
                                  onChanged: _onProviderChanged,
                                  hintText: 'Seleccione un proveedor',
                                ),

                          const SizedBox(height: 20),

                          DefaultTextField(
                            label: 'Stock:',
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es requerido';
                              }
                              final stock = int.tryParse(value.trim());
                              if (stock == null || stock < 0) {
                                return 'Ingrese un número válido para el stock';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          DefaultTextField(
                            label: 'Precio c/u:',
                            controller: _priceController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es requerido';
                              }
                              final price = double.tryParse(value.trim());
                              if (price == null || price < 0) {
                                return 'Ingrese un precio mayor o igual a cero';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.mainBlue, width: 2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: DefaultButton(
                text: _isLoading ? 'Agregando...' : 'Agregar producto',
                onPressed: _isLoading ? null : _createProduct,
              ),
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
