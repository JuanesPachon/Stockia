import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../shared/widgets/product_image.dart';
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

class EditProductPage extends StatefulWidget {
  final String id;
  final String name;
  final String category;
  final String? categoryId;
  final String provider;
  final String? providerId;
  final String stock;
  final String price;
  final String? imageUrl;

  const EditProductPage({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    this.categoryId,
    required this.provider,
    this.providerId,
    required this.stock,
    required this.price,
    this.imageUrl,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  int _currentBottomIndex = 1;
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final ProviderService _providerService = ProviderService();

  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;

  bool _isLoading = false;
  bool _isLoadingCategories = false;
  bool _isLoadingProviders = false;
  List<Category> _categories = [];
  List<Provider> _providers = [];
  String? _selectedCategoryId;
  String? _selectedProviderId;

  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imageChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _stockController = TextEditingController(text: widget.stock);
    _priceController = TextEditingController(text: widget.price);
    _selectedCategoryId = widget.categoryId;
    _selectedProviderId = widget.providerId;
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

          if (_selectedCategoryId != null) {
            final categoryExists = _categories.any(
              (cat) => cat.id == _selectedCategoryId,
            );
            if (!categoryExists) {
              _selectedCategoryId = null;
            }
          }

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
          _providers = response.data!
              .where((provider) => provider.status)
              .toList();

          if (_selectedProviderId != null) {
            final providerExists = _providers.any(
              (prov) => prov.id == _selectedProviderId,
            );
            if (!providerExists) {
              _selectedProviderId = null;
            }
          }

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

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageChanged = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageChanged = true;
    });
  }

  Future<void> _updateProduct() async {
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

      final response = _imageChanged
          ? await _productService.updateProductWithImage(
              widget.id,
              request,
              _selectedImage,
            )
          : await _productService.updateProduct(widget.id, request);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          final productName =
              response.data?.name ?? _nameController.text.trim();
          showCustomDialog(
            context,
            title: 'Se ha editado el producto:',
            message: productName,
            showSecondaryButton: false,
            primaryButtonText: "Aceptar",
            onPrimaryPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
          );
        } else {
          String errorMessage =
              'Error al actualizar el producto, intente nuevamente.';

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

  // Funciones auxiliares para los dropdowns
  List<String> _getCategoryItems() {
    return _categories.map((category) => category.name).toList();
  }

  String _getCategoryIdByName(String categoryName) {
    final category = _categories.firstWhere(
      (cat) => cat.name == categoryName,
      orElse: () =>
          Category(id: '', name: '', userId: '', createdAt: DateTime.now()),
    );
    return category.id;
  }

  String _getSelectedCategoryName(String? categoryId) {
    if (categoryId == null) return '';
    final category = _categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () =>
          Category(id: '', name: '', userId: '', createdAt: DateTime.now()),
    );
    return category.name;
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCategoryId = _getCategoryIdByName(newValue);
      });
    }
  }

  List<String> _getProviderItems() {
    return _providers.map((provider) => provider.name).toList();
  }

  String _getProviderIdByName(String providerName) {
    final provider = _providers.firstWhere(
      (prov) => prov.name == providerName,
      orElse: () => Provider(
        id: '',
        name: '',
        status: true,
        userId: '',
        createdAt: DateTime.now(),
      ),
    );
    return provider.id;
  }

  String _getSelectedProviderName(String? providerId) {
    if (providerId == null) return '';
    final provider = _providers.firstWhere(
      (prov) => prov.id == providerId,
      orElse: () => Provider(
        id: '',
        name: '',
        status: true,
        userId: '',
        createdAt: DateTime.now(),
      ),
    );
    return provider.name;
  }

  void _onProviderChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedProviderId = _getProviderIdByName(newValue);
      });
    }
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
            'Productos > Editar',
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
                      'Editar producto:',
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Imagen del producto:',
                                style: TextStyle(
                                  color: AppColors.mainBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: _selectedImage != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.mainBlue,
                                                width: 1,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    _selectedImage!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: GestureDetector(
                                                    onTap: _removeImage,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ProductImage(
                                            imageUrl: widget.imageUrl,
                                            width: 100,
                                            height: 100,
                                            fallbackIcon: Icons.inventory,
                                            fallbackIconSize: 40,
                                          ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _selectImage,
                                      icon: const Icon(Icons.image),
                                      label: Text(
                                        _selectedImage != null
                                            ? 'Cambiar imagen'
                                            : widget.imageUrl != null
                                            ? 'Cambiar imagen'
                                            : 'Seleccionar imagen',
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.mainBlue,
                                        side: const BorderSide(
                                          color: AppColors.mainBlue,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          205,
                                          187,
                                          152,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

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
                                        padding: const EdgeInsets.only(
                                          left: 12,
                                        ),
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
                                  value: _getSelectedCategoryName(
                                    _selectedCategoryId,
                                  ),
                                  items: [
                                    'Sin categoría',
                                    ..._getCategoryItems(),
                                  ],
                                  onChanged: (String? newValue) {
                                    if (newValue == 'Sin categoría') {
                                      setState(() {
                                        _selectedCategoryId = null;
                                      });
                                    } else {
                                      _onCategoryChanged(newValue);
                                    }
                                  },
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
                                      padding: const EdgeInsets.all(16.0),
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
                                        padding: const EdgeInsets.only(
                                          left: 12,
                                        ),
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
                                  value: _getSelectedProviderName(
                                    _selectedProviderId,
                                  ),
                                  items: [
                                    'Sin proveedor',
                                    ..._getProviderItems(),
                                  ],
                                  onChanged: (String? newValue) {
                                    if (newValue == 'Sin proveedor') {
                                      setState(() {
                                        _selectedProviderId = null;
                                      });
                                    } else {
                                      _onProviderChanged(newValue);
                                    }
                                  },
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
                                return 'Ingrese un precio válido';
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
                text: _isLoading ? 'Editando...' : 'Confirmar edición',
                onPressed: _isLoading ? null : _updateProduct,
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
