import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/provider_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/provider/create_provider_request.dart';
import '../../../../data/models/category/category.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';

import '../../../../shared/widgets/default_textarea.dart';
import '../../../../shared/widgets/default_dropdown.dart';

class AddProviderPage extends StatefulWidget {
  const AddProviderPage({super.key});

  @override
  State<AddProviderPage> createState() => _AddProviderPageState();
}

class _AddProviderPageState extends State<AddProviderPage> {
  int _currentBottomIndex = 1;
  final _formKey = GlobalKey<FormState>();
  final ProviderService _providerService = ProviderService();
  final CategoryService _categoryService = CategoryService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingCategories = false;
  List<Category> _categories = [];
  String? _selectedCategoryId;
  bool _selectedStatus = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
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

  Future<void> _createProvider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateProviderRequest(
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId,
        status: _selectedStatus,
      );

      final response = await _providerService.createProvider(request);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success && response.data != null) {
          final provider = response.data!;
          showCustomDialog(
            context,
            title: 'Se ha agregado el proveedor:',
            message: provider.name,
            showSecondaryButton: false,
            primaryButtonText: "Aceptar",
            onPrimaryPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
          );
        } else {
          String errorMessage =
              'Error al crear el proveedor, intente nuevamente.';

          final error = response.error?.toLowerCase() ?? '';

          if (error.contains('duplicate')) {
            errorMessage = 'Ya existe un proveedor con ese nombre.';
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

  List<String> _getStatusItems() {
    return ['Activo', 'Inactivo'];
  }

  String _getSelectedStatusName(bool status) {
    return status ? 'Activo' : 'Inactivo';
  }

  void _onStatusChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedStatus = newValue == 'Activo';
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
            'Proveedores > Agregar',
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
                      'Agregar nuevo proveedor:',
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
                            label: 'Nombre del proveedor:',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es requerido.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          DefaultTextField(
                            label: 'Contacto:',
                            controller: _contactController,
                            keyboardType: TextInputType.phone,
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
                                  hintText:
                                      'Selecciona una categoría (opcional)',
                                ),

                          const SizedBox(height: 20),

                          DefaultDropdown(
                            label: 'Estado:',
                            value: _getSelectedStatusName(_selectedStatus),
                            items: _getStatusItems(),
                            onChanged: _onStatusChanged,
                          ),
                          const SizedBox(height: 20),

                          DefaultTextArea(
                            label: 'Descripción:',
                            controller: _descriptionController,
                            maxLines: 6,
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
                text: _isLoading ? 'Agregando...' : 'Agregar proveedor',
                onPressed: _isLoading ? null : _createProvider,
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
