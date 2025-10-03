import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/expense_service.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/provider_service.dart';
import '../../../../data/models/expense/create_expense_request.dart';
import '../../../../data/models/category/category.dart';
import '../../../../data/models/provider/provider.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_textarea.dart';
import '../../../../shared/widgets/default_dropdown.dart';

class EditExpensePage extends StatefulWidget {
  final String id;
  final String title;
  final double amount;
  final String? categoryId;
  final String? providerId;
  final String description;

  const EditExpensePage({
    super.key,
    required this.id,
    required this.title,
    required this.amount,
    this.categoryId,
    this.providerId,
    required this.description,
  });

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  int _currentBottomIndex = 1;
  final _formKey = GlobalKey<FormState>();
  final ExpenseService _expenseService = ExpenseService();
  final CategoryService _categoryService = CategoryService();
  final ProviderService _providerService = ProviderService();

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

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
    _titleController = TextEditingController(text: widget.title);
    _amountController = TextEditingController(text: widget.amount.toString());
    _descriptionController = TextEditingController(text: widget.description);
    _selectedCategoryId = widget.categoryId;
    _selectedProviderId = widget.providerId;
    _loadCategories();
    _loadProviders();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
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
          _providers = response.data!.where((provider) => provider.status).toList();

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

  Future<void> _updateExpense() async {
    if (!_formKey.currentState!.validate()) return;

    // Double parsing validation
    double? amount;
    try {
      amount = double.parse(_amountController.text.trim());
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('El monto debe ser mayor a 0'),
            backgroundColor: Colors.red[800],
          ),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor ingrese un monto válido'),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateExpenseRequest(
        title: _titleController.text.trim(),
        amount: amount,
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId,
        providerId: _selectedProviderId,
      );

      final response = await _expenseService.updateExpense(widget.id, request);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success && response.data != null) {
          final expense = response.data!;
          showSuccessSnackBar(
            context,
            action: 'editó',
            resource: 'gasto',
            gender: 'el',
            resourceName: expense.title,
          );
          Navigator.pop(context, true);
        } else {
          String errorMessage =
              'Error al actualizar el gasto, intente nuevamente.';

          final error = response.error?.toLowerCase() ?? '';

          if (error.contains('duplicate')) {
            errorMessage = 'Ya existe un gasto con ese título.';
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
            'Gestión > Gastos > Editar',
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
                      'Editar gasto:',
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
                            label: 'Título del gasto:',
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El título es requerido';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          DefaultTextField(
                            label: 'Monto:',
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El monto es requerido';
                              }
                              final amount = double.tryParse(value.trim());
                              if (amount == null || amount <= 0) {
                                return 'Ingrese un monto válido mayor a 0';
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
                                  hintText: 'Selecciona una categoría',
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
                                  hintText: 'Selecciona un proveedor',
                                ),

                          const SizedBox(height: 20),

                          DefaultTextArea(
                            label: 'Descripción:',
                            controller: _descriptionController,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'La descripción es requerida';
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
                onPressed: _isLoading ? null : _updateExpense,
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
