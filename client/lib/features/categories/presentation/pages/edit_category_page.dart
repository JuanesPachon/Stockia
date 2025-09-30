import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/models/category/create_category_request.dart';
import '../../../../shared/widgets/app_navbar.dart';
import '../../../../shared/widgets/default_button.dart';
import '../../../../shared/widgets/default_textfield.dart';
import '../../../../shared/widgets/default_textarea.dart';

class EditCategoryPage extends StatefulWidget {
  final String id;
  final String name;
  final String description;

  const EditCategoryPage({
    super.key,
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  int _currentBottomIndex = 1;
  final _formKey = GlobalKey<FormState>();
  final CategoryService _categoryService = CategoryService();
  
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateCategoryRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );

      final response = await _categoryService.updateCategory(widget.id, request);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success && response.data != null) {
          final category = response.data!;
          showCustomDialog(
            context,
            title: 'Se ha editado la categoría:',
            message: category.name,
            showSecondaryButton: false,
            primaryButtonText: "Aceptar",
            onPrimaryPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context, true);
            },
          );
        } else {
          String errorMessage = 'Error al actualizar la categoría, intente nuevamente.';
          
          final error = response.error?.toLowerCase() ?? '';
          
          if (error.contains('duplicate')) {
            errorMessage = 'Ya existe una categoría con ese nombre.';
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
            'Gestión > Categorías > Editar',
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
                      'Editar categoría:',
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
                            label: 'Nombre de la categoría:',
                            controller: _nameController,
                            hintText: 'Ingresa el nombre de la categoría',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Este campo es requerido';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          DefaultTextArea(
                            label: 'Descripción:',
                            controller: _descriptionController,
                            hintText: 'Descripción opcional de la categoría',
                            maxLines: 5,
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
                text: _isLoading ? 'Guardando...' : 'Confirmar edición', 
                onPressed: _isLoading ? null : _updateCategory,
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